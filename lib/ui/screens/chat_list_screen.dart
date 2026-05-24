import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shlus/api/api.dart';
import 'package:shlus/models/chat.dart';
import 'package:shlus/ui/screens/chat_screen.dart';
import 'package:shlus/ui/screens/communication_screen.dart';
import 'package:shlus/ui/widgets/chat_item.dart';

class ChatListScreen extends StatefulWidget {

  const ChatListScreen({super.key});
  
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();

}

class _ChatListScreenState extends State<ChatListScreen> {

  List<Chat> _chats = [];
  final PhoenixService _service = PhoenixService();
  bool _isLoading = true;
  String helloMessage = "Hi)";

  Future<void> _loadRooms() async {

    try{
      
      final chats = await _service.getChats("f47ac10b-58cc-4372-a567-0e02b2c3d479");

      setState(() {
        _chats = chats;
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

  void onTap(Chat chat) async {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(chat: chat)
      )
    );

  }

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CommunicationScreen()
            )
          );

        },
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : _chats.isEmpty
          ? Center(child: Text(helloMessage))
          : ListView.builder(

            itemCount: _chats.length,
            itemBuilder: (context, index) {
              final chat = _chats[index];

              return ChatItem(
                chat: chat,
                onTap: () => onTap(chat)
              );
            },
          ),
      appBar: AppBar(
        title: Text(
          "Shlus",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search)
          ),
          PopupMenuButton<String>(
            color: Colors.white,
            onSelected: (value) {

              switch(value) {

                case "new_group":
                  setState(() {
                    helloMessage = "New group";
                  });
                  break;

                case "new_channel":
                  setState(() {
                    helloMessage = "New channel";
                  });
                  break;
              }

            }, 
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "new_group",
                child: Text(
                  "Создать группу"
                )
              ),
              const PopupMenuItem(
                value: "new_channel",
                child: Text(
                  "Создать канал"
                )
              ),
            ],
          ),
        ],
      ),

    );
  }

}