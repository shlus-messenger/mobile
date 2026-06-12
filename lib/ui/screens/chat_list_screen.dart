import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shlus/api/api.dart';
import 'package:shlus/models/chat.dart';
import 'package:shlus/ui/screens/auth_screen.dart';
import 'package:shlus/ui/screens/chat_screen.dart';
import 'package:shlus/ui/screens/communication_screen.dart';
import 'package:shlus/ui/screens/entry_screen.dart';
import 'package:shlus/ui/widgets/chat_item.dart';
import 'package:shlus/ui/widgets/logo.dart';

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
  List<Chat> _selectedChats = [];

  void onTap(Chat chat) async {

    if(_selectedChats.length == 0)
    {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(chat: chat)
        )
      );
    }
    else
    {
      if(_selectedChats.contains(chat))
      {
        setState(() {
          _selectedChats.remove(chat);
        });
      }
      else
      {
        setState(() {
          _selectedChats.add(chat);
        });
      }
    }

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
    
    _service.onAddInNewChat = (payload) {

      if(!mounted) return;

      setState(() {

        _chats.insert(0, Chat.fromJson(payload));

      });
    };

    _service.onUserDeleteChat = (payload) {

      if(!mounted) return;

      setState(() {
        
        int targetChatIndex = _chats.indexWhere((chat) => chat.id == payload["room_id"]);
        int targetSelectedChatIndex = _chats.indexWhere((chat) => chat.id == payload["room_id"]);

        _chats.removeAt(targetChatIndex);
        _selectedChats.removeAt(targetSelectedChatIndex);

      });

    };

    _service.onLastMessageUpdated = (payload) {

      if(!mounted) return;

      setState(() {

        int targetChatIndex = _chats.indexWhere((chat) => chat.id == payload["room_id"]);

        final chat = _chats[targetChatIndex];

        chat.lastMessage = payload["last_message"];
        chat.lastMessageAt = DateTime.parse(payload["last_message_at"]);
        chat.lastMessageUserName = payload["last_message_user_name"];

        _chats.removeAt(targetChatIndex);
        _chats.insert(0, chat);
        
      });
    };

    _connectToBackend();
  }

  Future<void> _connectToBackend() async {

    final pref = await SharedPreferences.getInstance();

    print("Updated token: ${pref.get("token")}");

    await _service.initSocket();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    print("Ширина: ${MediaQuery.of(context).size.width}");
    print("Высота: ${MediaQuery.of(context).size.height}");
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _selectedChats.length == 0 ? AppBar(
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
                
                case "exit":
                  _service.logout();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EntryScreen()
                    )
                  );
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
              const PopupMenuItem(
                value: "exit",
                child: Text(
                  "Выйти",
                  style: TextStyle(
                    color: Colors.red
                  ),
                )
              ),
            ],
          ),
        ],
      )
      : AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            setState(() {
              _selectedChats = [];
            });
          },
        ),
        title: Text(
          _selectedChats.length.toString()
        ),
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: Icon(Icons.volume_up_outlined),
          ),
          IconButton(
            onPressed: () {

            },
            icon: Icon(Icons.archive_outlined),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    actionsPadding: EdgeInsets.only(bottom: 5.h, right: 10.w),
                    contentPadding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                    actions: [
                      TextButton(
                        child: Text(
                          "Отмена",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text(
                          _selectedChats.length > 1 ? "Удалить" : ["group", "dialog"].contains(_selectedChats[0].type) ? "Удалить чат" : "Покинуть канал",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.red,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        onPressed: () async {

                          await Future.wait(
                            _selectedChats.map((chat) => _service.deleteChat(chat.id))
                          );

                          Navigator.pop(context);
                        },
                      )
                    ],
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(_selectedChats.length == 1) ...[
                              Logo(
                                logo: _selectedChats[0].logo,
                                name: _selectedChats[0].name
                              ),
                              SizedBox(width: 10.w),
                            ],
                            Text(
                              _selectedChats.length > 1 ? "Удалить ${_selectedChats.length} чата" : _selectedChats[0].type == "group" ? "Покинуть группу" : _selectedChats[0].type == "channel" ? "Покинуть канал" : "Удалить чат",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500
                              ),
                              softWrap: true,
                            )
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: _selectedChats.length > 1 ? "Вы точно хотите удалить выбранные чаты?" : _selectedChats[0].type == "group" ? "Вы точно хотите удалить и покинуть группу " : _selectedChats[0].type == "channel" ? "Вы точно хотите покинуть " : "Вы точно хотите удалить чат с ",
                                style: TextStyle(
                                  fontSize: 15.sp
                                ),
                              ),
                              if(_selectedChats.length == 1) ...[
                                TextSpan(
                                  text: _selectedChats[0].name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.sp
                                  )
                                ),
                                const TextSpan(
                                  text: "?",
                                  style: TextStyle(
                                    fontSize: 15
                                  )
                                )
                              ]
                            ]
                          )
                        )
                      ]
                    )
                  );
                }
              );
            },
            icon: Icon(Icons.delete_outline),
          ),
          IconButton(
            onPressed: () {
              
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
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
                isSelected: _selectedChats.contains(chat),
                onTap: () => onTap(chat),
                onLongPress: () => {
                  setState(() {
                    _selectedChats.add(chat);
                  })
                },
              );
            },
          ),
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
    );
  }
}