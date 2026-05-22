import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shlus/api/api.dart';
import 'package:shlus/models/room.dart';
import 'package:shlus/ui/widgets/chat_item.dart';

class ChatScreen extends StatefulWidget {

  const ChatScreen({super.key});
  
  @override
  State<ChatScreen> createState() => _ChatScreenState();

}

class _ChatScreenState extends State<ChatScreen> {

  List<Room> _rooms = [];
  final PhoenixService _service = PhoenixService();
  bool _isLoading = true;

  Future<void> _loadRooms() async {

    try{
      
      final rooms = await _service.getChats("f47ac10b-58cc-4372-a567-0e02b2c3d479");

      setState(() {
        _rooms = rooms;
        _isLoading = false;
      });

    }

    catch(e){
      setState(() {
        _isLoading = false;
      });

      throw e;
    }

  }

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  @override
  Widget build(BuildContext context) {

    return ListView.builder(

      itemCount: _rooms.length,
      itemBuilder: (context, index) {
        final room = _rooms[index];

        return ChatItem(
          room: room,
          onTap: () => {},
        );
      },

    );

  }

}