import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shlus/models/chat.dart';
import 'package:shlus/api/api.dart';
import 'package:shlus/models/message.dart';
import 'package:shlus/ui/widgets/message_item.dart';
import 'dart:math';

class ChatScreen extends StatefulWidget {

  final Chat chat;

  ChatScreen({
    super.key,
    required this.chat
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();

}

class _ChatScreenState extends State<ChatScreen> {

  final PhoenixService _service = PhoenixService();
  List<Message> _messages = [];
  bool _isLoading = true;
  final TextEditingController _textContoller = TextEditingController();
  Map<String, dynamic> _onlineUsers = {};
  Map<String, bool> _typingUser = {};
  Timer? _typingTimer;
  

  @override
  void initState() {

    super.initState();

    _service.onNewMessage = (payload) {
      if(!mounted) return;
      setState(() {

        final newMessage = Message.fromJson(payload);
        _messages.add(newMessage);

      });

    };

    _service.onPresenceState = (payload) {

      if(!mounted) return;

      setState(() {
        _onlineUsers = Map<String, dynamic>.from(payload);
      }); 

    };

    _service.onPresenceDiff = (payload) {

      if(!mounted) return;

      final joins = Map<String, dynamic>.from(payload["joins"]);
      final leaves = Map<String, dynamic>.from(payload["leaves"]);

      setState(() {
        
        _onlineUsers.addAll(joins);

        leaves.keys.forEach((key) {

          _onlineUsers.remove(key);

        });

      }); 

    };

    _service.onTyping = (payload) {

      if(!mounted) return;

      setState(() {
          _typingUser!.addAll(Map<String, bool>.from(payload));
      });

    };

    Future.delayed(Duration(milliseconds: 500), () {

      _service.joinToChat(widget.chat.id);

      _loadMessages();

    });

  }

  void _onTyping(String text) {

    _service.sendTyping(true);

    _typingTimer?.cancel();

    _typingTimer = Timer(
      Duration(seconds: 1),
      () {
        _service.sendTyping(false);
      }
    );

  }

  void _loadMessages() async {

    try {

      final messages = await _service.getMessages(widget.chat.id);

      setState(() {

        _messages = messages;
        _isLoading = false;

      });

    }

    catch(e) {
      _isLoading = false;
      throw Exception(e);
    }

  }

  void _sendMessage(String text) {

    print("Text: $text");

    if (text.trim().isEmpty) return;

    _service.sendMessage(text);  
  }

  @override
  void dispose() {

    _textContoller.dispose();
    _service.leaveChat(widget.chat.id);
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: Row(
            children: [
              if(widget.chat.logoUrl != null) ...[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.chat.logoUrl!
                  ),
                ),
              ]
              else ...[
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, Random().nextInt(256), Random().nextInt(256), Random().nextInt(256)),
                  child: Text(
                    widget.chat.name[0],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white
                    )
                  ),
                ),
              ],
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.name,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    _typingUser!.containsValue(true) ? "${_typingUser!.entries.where((entry) => entry.value).map((entry) => entry.key).firstOrNull} печатает..." : "${widget.chat.members.length} участника, ${_onlineUsers.length != 0 ? "${_onlineUsers.length} онлайн" : ""}",
                    style: TextStyle(
                      fontSize: 12,
                      color: _typingUser.containsValue(true) ? Colors.blue : Colors.grey.shade500
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: Colors.grey.shade300,
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return (
                        Column(
                          children: [
                            MessageItem(message: _messages[index], isMe: _messages[index].userId == "a97f852a-0f86-462f-8814-f119d755cdb1"),
                            const SizedBox(height: 20)
                          ],
                        )
                      );
                    },
                  )
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white
                ),
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: _onTyping,
                        controller: _textContoller,
                        decoration: InputDecoration(
                          hintText: "Сообщение: ",
                          hintStyle: TextStyle(
                            fontSize: 14
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none
                          )
                        ),
                        onSubmitted: _sendMessage,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => _sendMessage(_textContoller.text),
                    )
                  ],
                )
              )
            )
          ],
        )
      )
    );
  }
}