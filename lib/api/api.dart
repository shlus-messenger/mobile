import 'dart:io';
import 'package:shlus/models/message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shlus/models/chat.dart';

class PhoenixService {

  String? _chatId;
  final String _userId = "a97f852a-0f86-462f-8814-f119d755cdb1"; // Это константы из async storage
  final String _userName = "Mark"; // Это константы из async storage

  static final PhoenixService _instance = PhoenixService._internal();
  factory PhoenixService() => _instance;

  PhoenixService._internal();

  WebSocketChannel? _socket;
  Timer? _heartbeatTimer;
  bool _isJoinedToUserChannel = false;
  bool _isJoinedToChatChannel = false;
  String? _joinRef;
  int _retryAttempts = 0;
  List<int> _retryIntervals = [1, 2, 4, 8, 15, 30];
  Timer? _retryTimer;
  Function(Map<String, dynamic>)? onNewMessage;
  Function(List<dynamic>)? onChatsList;
  Function(Map<String, dynamic>)? onChatUpdated;
  Function(Map<String, dynamic>)? onPresenceState;
  Function(Map<String, dynamic>)? onPresenceDiff;
  Function(Map<String, dynamic>)? onTyping;

  Future<void> initSocket() async {

    try {
        final wsUrl = Uri.parse("ws://10.0.2.2:4000/socket/websocket/?vsn=2.0.0&user_id=$_userId&user_name=$_userName");

        final socket = WebSocketChannel.connect(wsUrl);

        await socket.ready;

        _socket = socket;

        _socket!.stream.listen(

            (message) {

                print("Message: $message");
                _handleMessage(message);

            },

            onError: (error) {
                _isJoinedToChatChannel = false;
                _retryInitSocket();
                print(error);
            },

            onDone: () {
                _isJoinedToChatChannel = false;
                _isJoinedToUserChannel = false;

                _retryInitSocket();
            }

        );
        
        _retryAttempts = 0;
        _joinToUserChannel();
        _retryTimer?.cancel();
    }

    catch(e){

        _isJoinedToChatChannel = false;
        _isJoinedToUserChannel = false;

        _retryInitSocket();

        print(e);
    }

  }

  void _retryInitSocket() {

    print("Retry...");

    if(_retryTimer?.isActive ?? false) return;

    _socket?.sink.close();
    _heartbeatTimer?.cancel();

    _retryTimer = Timer(
        Duration(seconds: _retryIntervals[_retryAttempts]),
        () {
            initSocket();
        }
    );

    if(_retryAttempts < _retryIntervals.length - 1) _retryAttempts++;
    
  }

  void _joinToUserChannel() {

    print("Присоединяемся к каналу пользователя...");

    final ref = DateTime.now().millisecondsSinceEpoch.toString();

    final joinMsg = [ref, ref, "user:$_userId", "phx_join", {}];
    _socket!.sink.add(jsonEncode(joinMsg));
    
  }

  void joinToChat(String chatId) {

    print("Присоединяемся к чату...");

    final ref = DateTime.now().millisecondsSinceEpoch.toString();

    _joinRef = ref;

    final joinMsg = [ref, ref, "room:$chatId", "phx_join", {}];
    _socket!.sink.add(jsonEncode(joinMsg));

  }

  void leaveChat(String chatId) {

    final ref = DateTime.now().millisecondsSinceEpoch.toString();

    print("Выходим из чата...");

    final leaveMsg = [_joinRef, ref, "room:$chatId", "phx_leave", {}];

    _socket!.sink.add(jsonEncode(leaveMsg));

    _joinRef = null;
    _isJoinedToChatChannel = false;
    _chatId = null;

  }

  void sendMessage(String body) {

    if(!_isJoinedToChatChannel) {

     print("You're not in chat");

      return;

    }

    print("Отправляем сообщение: $body...");

    final ref = DateTime.now().millisecondsSinceEpoch.toString();

    final msg = [_joinRef, ref, "room:$_chatId", "new_message", {"body": body}];

    print("Полный массив: $msg");
    print("JSON: $msg");

    _socket!.sink.add(jsonEncode(msg));
    print("Отправили сообщение");
    
  }

  void _handleMessage(String message) {

    print("Получили сообщение: $message");

    try {

      final data = jsonDecode(message);
      String topic = data[2];
      final event = data[3];
      final payload = data[4];

      if(event == "phx_reply" && payload["status"] == "ok") {

        if(topic.startsWith("user:"))
            _isJoinedToUserChannel = true;
        
        else if(topic.startsWith("room:")) {

            _isJoinedToChatChannel = true;
            _chatId = topic.split("room:")[1];

        }

        _startHeartbeat();

      }

      else if(event == "new_message") {

        onNewMessage?.call(payload);

      }

      else if(event == "rooms_list") {

        print("Получен список комнат");

        onChatsList?.call(payload["rooms"]);

      }

      else if(event == "presence_state") {

        print("Получено состояние");

        onPresenceState?.call(payload);

      }

      else if(event == "presence_diff") {

        print("Получено состояние: $payload");

        onPresenceDiff?.call(payload);

      }

      else if(event == "typing") {

        print("Кто то что то печатает...");

        onTyping?.call(payload);

      }

      else if(event == "chat_updated") {

        print("Чат был обновлён");

        onChatUpdated?.call(payload);

      }

    }

    catch(e) {

      print(e);
      
    }

  }

  void sendTyping(bool typing) {

    if(!_isJoinedToChatChannel) {

        print("You're not in chat");
        return;

    }

    final ref = DateTime.now().millisecondsSinceEpoch.toString();

    final msg = [
        
        _joinRef,
        ref,
        "room:$_chatId",
        "typing",
        {
            _userName: typing,
        }

    ];

    _socket!.sink.add(jsonEncode(msg));

  }

  void _startHeartbeat() {

    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if(_socket != null) {

        final ref = DateTime.now().millisecondsSinceEpoch.toString();

        final heartbeatMsg = [null, ref, "phoenix", "heartbeat", {}];

        _socket!.sink.add(jsonEncode(heartbeatMsg));

      }
    });

  }

  Future<bool> createGroup(String groupName, File? logo, {bool isPublic = true}) async {

    var request = http.MultipartRequest("POST", Uri.parse("http://10.0.2.2:4000/api/rooms"));

    request.fields["name"] = groupName;
    request.fields["description"] = "";
    request.fields["user_id"] = _userId;
    request.fields["type"] = "group";
    request.fields["accessability"] = isPublic ? "public" : "private";

    if(logo != null) {
      request.files.add(
        await http.MultipartFile.fromPath("logo", logo.path)
      );
    }

    var response = await request.send();

    return response.statusCode == 200;

  }

  Future<List<Message>> getMessages(String chatId) async {

    final response = await http.get(
      Uri.parse("http://10.0.2.2:4000/api/messages/$_userId/$chatId")
    );

    if(response.statusCode == 200) {

      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => Message.fromJson(json)).toList();

    }

    else {
      throw Exception("Failed to load messages");
    }
  
  }

  Future<List<Chat>> getChats() async {

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