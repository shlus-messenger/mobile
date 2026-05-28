import 'package:flutter/material.dart';
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
  String helloMessage = "Здесь пока что пусто...";

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
    _service.onChatsList = (payload) {

      if(!mounted) return;

      setState(() {

        _chats = payload.map<Chat>((chat) => Chat.fromJson(chat)).toList();
        _isLoading = false;

      });

    };
    _service.onChatUpdated = (payload) {

      if(!mounted) return;

      setState(() {

        int targetChatIndex = _chats.indexWhere((chat) => chat.id == payload["room_id"]);

        if(targetChatIndex != -1) {

          final chat = _chats[targetChatIndex];

          chat.lastMessage = payload["last_message"];
          chat.lastMessageAt = DateTime.parse(payload["last_message_at"]);
          chat.lastMessageUserName = payload["last_message_user_name"];

          _chats.removeAt(targetChatIndex);
          _chats.insert(0, chat);

        }

        else {
            _chats.insert(0, Chat.fromJson(payload));
        }

      });
    };

    _connectToBackend();
  }

  Future<void> _connectToBackend() async {

    await _service.initSocket();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      floatingActionButton: FloatingActionButton(
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
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