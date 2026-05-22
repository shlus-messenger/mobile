//import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shlus/models/room.dart';

class PhoenixService {

  final String roomId = "";
  final String userId = "";
  final String userName = "";

  // WebSocketChannel? _channel;
  // Timer? _heartbeatTimer;
  // bool _isJoined = false;

  Future<List<Room>> getChats(String userId) async {

    final response = await http.get(
      Uri.parse("http://10.0.2.2:4000/api/rooms/$userId"),
    );

    if(response.statusCode == 200) {

      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> roomsJson = data["rooms"];

      return roomsJson.map((json) => Room.fromJson(json)).toList();

    }

    else {
      throw Exception("Failed to load chat list");
    }

  }
}