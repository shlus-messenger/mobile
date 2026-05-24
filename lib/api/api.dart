import 'package:shlus/models/message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shlus/models/chat.dart';

class PhoenixService {

  final String chatId = "";
  final String userId = "";
  final String userName = "";

  WebSocketChannel? _channel;
  Timer? _heartbeatTimer;
  bool _isJoined = false;
  String? _joinRef;
  Function(Map<String, dynamic>)? onNewMessage;

  void initChannel(String chatId, String userId, String userName) {

    final wsUrl = Uri.parse("ws://10.0.2.2:4000/socket/websocket/?vsn=2.0.0&user_id=$userId&user_name=$userName");

    _channel = WebSocketChannel.connect(wsUrl);

    _channel!.stream.listen(

      (message) {

        print("Message: $message");
        _handleMessage(message);

      },

      onError: (error) {
        _isJoined = false;
        throw Exception(error);
      },

      onDone: () {
        _isJoined = false;
      }

    );

  }

  void joinToChannel(String chatId, String userId, String userName) {

    print("Присоединяемся к каналу...");

    final ref = DateTime.now().millisecondsSinceEpoch.toString();

    _joinRef = ref;

    final joinMsg = [ref, ref, "room:$chatId", "phx_join", {}];
    _channel!.sink.add(jsonEncode(joinMsg));

  }

  void leaveChannel(String chatId, String userId, String userName) {

    final ref = DateTime.now().millisecondsSinceEpoch.toString();

    final leaveMsg = [ref, ref, "room:$chatId", "phx_leave", {}];

    _channel!.sink.add(jsonEncode(leaveMsg));

  }

  void sendMessage(String chatId, String userId, String userName, String body) {

    if(!_isJoined) {

      print("_isJoined = false");

      return;

    }

    print("Отправляем сообщение: $body...");

    final ref = DateTime.now().millisecondsSinceEpoch.toString();

    final msg = [_joinRef, ref, "room:$chatId", "new_message", {"body": body}];

    print("Полный массив: $msg");
    print("JSON: $msg");

    _channel!.sink.add(jsonEncode(msg));
    print("Отправили сообщение");
    
  }

  void _handleMessage(String message) {

    print("Получили сообщение: $message");

    try {

      final data = jsonDecode(message);
      final event = data[3];
      final payload = data[4];

      if(event == "phx_reply" && payload["status"] == "ok") {

        _isJoined = true;
        _startHeartbeat();

      }

      else if(event == "new_message") {

        onNewMessage?.call(payload);

      }

    }

    catch(e) {

      throw Exception(e);
      
    }

  }

  void _startHeartbeat() {

    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if(_channel != null && _isJoined) {

        final ref = DateTime.now().millisecondsSinceEpoch.toString();

        final heartbeatMsg = [null, ref, "phoenix", "heartbeat", {}];

        _channel!.sink.add(jsonEncode(heartbeatMsg));

      }
    });

  }

  Future<List<Message>> getMessages(String chatId, String userId) async {

    final response = await http.get(
      Uri.parse("http://10.0.2.2:4000/api/messages/$userId/$chatId")
    );

    if(response.statusCode == 200) {

      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => Message.fromJson(json)).toList();

    }

    else {
      throw Exception("Failed to load messages");
    }
  
  }

  Future<List<Chat>> getChats(String userId) async {

    final response = await http.get(
      Uri.parse("http://10.0.2.2:4000/api/rooms"),
    );

    if(response.statusCode == 200) {

      final List<dynamic> data = jsonDecode(response.body);

      print("Response: ${data}");

      return data.map((json) => Chat.fromJson(json)).toList();

    }

    else {
      throw Exception("Failed to load chat list");
    }

  }
}