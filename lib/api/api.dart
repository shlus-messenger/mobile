import 'dart:io';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shlus/models/message.dart';
import 'package:shlus/models/reaction.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shlus/models/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class PhoenixService {

  String? _chatId;
  late String _userId;
  late String _userName;
  late String _token;

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
	late String apiUrl;
  Function(Map<String, dynamic>)? onNewMessage;
  Function(List<dynamic>)? onChatsList;
  Function(Map<String, dynamic>)? onAddInNewChat;
  Function(Map<String, dynamic>)? onPresenceState;
  Function(Map<String, dynamic>)? onPresenceDiff;
  Function(Map<String, dynamic>)? onLastMessageUpdated;
  Function(Map<String, dynamic>)? onUserDeleteChat;
  Function(Reaction)? onAddReaction;
  Function(Map<String, dynamic>)? onDeleteReaction;
  Function(Map<String, dynamic>)? onTyping;

  Future<void> initData() async {

    final pref = await SharedPreferences.getInstance();

    _userId = pref.getString("userId") ?? "";
    _userName = pref.getString("userName") ?? "";
    _token =pref.getString("token") ?? "";

		if(kDebugMode) {
			apiUrl = dotenv.get("DEV_API_URL");
		}
		else if(kReleaseMode) {
			apiUrl = dotenv.get("RELEASE_API_URL");
		}

  }

  Future<void> initSocket() async {

    if(_userId == "" && _token == "" && _userName == "") return;

    try {
        final wsUrl = Uri.parse("ws://$apiUrl/socket/websocket/?vsn=2.0.0&user_id=$_userId&user_name=$_userName&token=$_token");

        final socket = WebSocketChannel.connect(wsUrl);


        await socket.ready;

        _socket = socket;

        _socket!.stream.listen(

            (message) {
                _handleMessage(message);
            },

            onError: (error) async {
                _isJoinedToChatChannel = false;
                await _retryInitSocket();
            },

            onDone: () async {
                _isJoinedToChatChannel = false;
                _isJoinedToUserChannel = false;

                await _retryInitSocket();
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

  Future<void> _retryInitSocket() async {

    if(_userId == "" && _token == "" && _userName == "") return;

    if(_retryTimer?.isActive ?? false) return;

    await _socket?.sink.close();
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

    final ref = DateTime.now().millisecondsSinceEpoch.toString();

    final joinMsg = [ref, ref, "user:$_userId", "phx_join", {}];
    _socket!.sink.add(jsonEncode(joinMsg));
    
  }

  void joinToChat(String chatId) {

    final ref = DateTime.now().millisecondsSinceEpoch.toString();

    _joinRef = ref;

    final joinMsg = [ref, ref, "room:$chatId", "phx_join", {}];
    _socket!.sink.add(jsonEncode(joinMsg));

  }

  void deleteReaction(String messageId, int reactionId) {

    if(!_isJoinedToChatChannel) {

      return;

    }

    final ref = DateTime.now().millisecondsSinceEpoch.toString();

    final msg = [_joinRef, ref, "room:$_chatId", "delete_reaction", {"message_id": messageId, "reaction_id": reactionId}];

    _socket!.sink.add(jsonEncode(msg));

  }

  void addReaction(String messageId, String reaction) {

    if(!_isJoinedToChatChannel) {

      return;

    }

    final ref = DateTime.now().millisecondsSinceEpoch.toString();

    final msg = [_joinRef, ref, "room:$_chatId", "add_reaction", {"message_id": messageId, "emoji": reaction}];

    _socket!.sink.add(jsonEncode(msg));

  }

  void leaveChat(String chatId) {

    final ref = DateTime.now().millisecondsSinceEpoch.toString();

    final leaveMsg = [_joinRef, ref, "room:$chatId", "phx_leave", {}];

    _socket!.sink.add(jsonEncode(leaveMsg));

    _joinRef = null;
    _isJoinedToChatChannel = false;
    _chatId = null;

  }

  void sendMessage(String body, {String? replyTo = null}) {

    if(!_isJoinedToChatChannel) {

      return;

    }

    final ref = DateTime.now().millisecondsSinceEpoch.toString();

    final msg = [_joinRef, ref, "room:$_chatId", "new_message", {"body": body, "reply_to": replyTo}];

    _socket!.sink.add(jsonEncode(msg));
    
  }

  Future<void> deleteChat(chatId) async {

    await http.delete(Uri.parse("http://$apiUrl/rooms/$_userId/$chatId"));

  }

  void _handleMessage(String message) {

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
            print(payload);

        }

        _startHeartbeat();

      }

      else if(event == "new_message") {

        print("Получено сообщение: ${payload}");

        onNewMessage?.call(payload);

      }

      else if(event == "rooms_list") {

        onChatsList?.call(payload["rooms"]);

      }

      else if(event == "presence_state") {

        onPresenceState?.call(payload);

      }

      else if(event == "presence_diff") {

        onPresenceDiff?.call(payload);

      }

      else if(event == "typing") {

        onTyping?.call(payload);

      }

      else if(event == "add_in_new_chat") {
        
        onAddInNewChat?.call(payload);

      }

      else if(event == "last_message_updated") {

        onLastMessageUpdated?.call(payload);

      }

      else if(event == "user_delete_chat") {

        onUserDeleteChat?.call(payload);

      }

      else if(event == "add_reaction") {

        onAddReaction?.call(Reaction.fromJson(payload));
        
      }

      else if(event == "delete_reaction") {

        onDeleteReaction?.call(payload);
        
      }

    }

    catch(e) {

      print(e);
      
    }

  }

  void sendTyping(bool typing) {

    if(!_isJoinedToChatChannel) {
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

	Future<void> logout() async {

		final result = await http.delete(
			Uri.parse("http://$apiUrl/user"),
			body: {
				"user_id": _userId
			}, 
			headers: {
				"Authorization": "Bearer $_token"
			}
		);

		if(result.statusCode == 200) {

			_userId = "";
			_userName = "";
			_token = "";

			final pref = await SharedPreferences.getInstance();
			await pref.remove("userId");
			await pref.remove("userName");
			await pref.remove("token");

      await _socket?.sink.close();
      _socket = null;
      _retryTimer?.cancel();
      _retryTimer = null;
      _retryAttempts = 0;
      _isJoinedToChatChannel = false;
      _isJoinedToUserChannel = false;
		}

	}

	Future<void> login(String login, String password) async {

		try {
      final result = await http.post(Uri.parse("http://$apiUrl/user/login"), body: {
        "login": "@$login",
        "password": password
      });

      if(result.statusCode == 200)
      {
          final data = jsonDecode(result.body);

          _userId = data["user_id"];
          _userName = data["user_name"];
          _token = data["token"];

          final pref = await SharedPreferences.getInstance();
          await pref.setString("userId", data["user_id"]);
          await pref.setString("userName", data["user_name"]);
          await pref.setString("token", data["token"]);
      }

      else {
        throw result.statusCode;
      }
    } on SocketException catch(_) {
      rethrow;
    }

    catch(e) {
      throw Exception(e);
    }

	}

	Future<void> createAccount(String name, String login, String password, String aboutMe, File? avatar) async {

		try {

			var request = http.MultipartRequest("POST", Uri.parse("http://$apiUrl/user"));

			request.fields["name"] = name;
			request.fields["login"] = login;
			request.fields["password"] = password;
			request.fields["aboutMe"] = aboutMe;
			
			if(avatar != null) {
				request.files.add(
					await http.MultipartFile.fromPath("avatar", avatar.path)
				);
			}
			else {
				request.fields["avatar"] = "#${Random().nextInt(0xFFFFF + 1).toRadixString(16).padLeft(6, '0').toUpperCase()}";
			}

			var response = await request.send();

			final body = await response.stream.bytesToString();

    	if(response.statusCode == 200) {

				final data = jsonDecode(body);

				_userId = data["user_id"];
				_userName = data["user_name"];
				_token = data["token"];

				final pref = await SharedPreferences.getInstance();
				await pref.setString("userId", data["user_id"]);
				await pref.setString("userName", data["user_name"]);
				await pref.setString("token", data["token"]);

			}

      else if(response.statusCode == 403) {

        throw Exception(body);

      }

      else {
        throw Exception("Internal service error");
      }

		}
		catch(e) {
			throw Exception(e);
		}

	}

  Future<bool> isUserExist(String login) async {

    try {
      final result = await http.post(Uri.parse("http://$apiUrl/user/check_existing"), body: {
        "login": "@$login",
      });

      return jsonDecode(result.body)["exists"];

    } on SocketException catch(_) {
      rethrow;
    }

    catch(e) {
      throw Exception(e);
    }

  }

  Future<bool> createChat(String chatName, String type, File? logo, {bool isPublic = true, String description = ""}) async {

    var request = http.MultipartRequest("POST", Uri.parse("http://$apiUrl/rooms"));

    request.headers["Authorization"] = "Bearer $_token";

    request.fields["name"] = chatName;
    request.fields["description"] = description;
    request.fields["user_id"] = _userId;
    request.fields["type"] = type;
    request.fields["accessability"] = isPublic ? "public" : "private";

    if(logo != null) {
      request.files.add(
        await http.MultipartFile.fromPath("logo", logo.path)
      );
    }
    else {
      request.fields["logo"] = "#${Random().nextInt(0xFFFFF + 1).toRadixString(16).padLeft(6, '0').toUpperCase()}";
    }

    var response = await request.send();

    return response.statusCode == 200;

  }

  Future<List<Message>> getMessages(String chatId) async {

    final response = await http.get(
      Uri.parse("http://$apiUrl/messages/$_userId/$chatId"),
      headers: {
        "Authorization": "Bearer $_token"
      }
    );

    if(response.statusCode == 200) {

      final List<dynamic> data = jsonDecode(response.body);

      print(data);

      return data.map((json) => Message.fromJson(json)).toList();

    }

    else {
      throw Exception("Failed to load messages");
    }
  
  }


}