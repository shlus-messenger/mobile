import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shlus/models/chat.dart';
import 'package:shlus/api/api.dart';
import 'package:shlus/models/message.dart';
import 'package:shlus/models/reaction.dart';
import 'package:shlus/ui/screens/group_info_screen.dart';
import 'package:shlus/ui/widgets/logo.dart';
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
	final Map<int, double> _dragOffsets = {};
	final FocusNode _inputFocusNode = FocusNode();
  Message? _replyTo;
  late String _userId;
  

  @override
  void initState() {

    super.initState();

    debugPrint("Мы в чате...");

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

    _service.onAddReaction = (payload) {

      if(!mounted) return;

      setState(() {
        
        int messageIndex = _messages.indexWhere((message) => message.id == payload.messageId);

        _messages[messageIndex].reactions?.add(payload);

      });

    };

    _service.onDeleteReaction = (payload) {

      if(!mounted) return;

      setState(() {
        
        int messageIndex = _messages.indexWhere((message) => message.id == payload["message_id"]);

        _messages[messageIndex].reactions?.removeWhere((reaction) => reaction.id == payload["id"]);

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

    loadData();

  }

  Future<void> loadData() async {
    final pref = await SharedPreferences.getInstance();

    _userId = pref.getString("userId")!;
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

    if (text.trim().isEmpty) return;

    _service.sendMessage(text, replyTo: _replyTo?.id);

    _textContoller.text = "";
    _replyTo = null;
  }

  @override
  void dispose() {

    _textContoller.dispose();
    _service.leaveChat(widget.chat.id);
		_inputFocusNode.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
					onTap: () {
						Navigator.push(
							context,
							MaterialPageRoute(
								builder: (context) => GroupInfoScreen(chat: widget.chat)
							)
						);
					},
          child: Row(
            children: [
              Logo(
								logo: widget.chat.logo,
								name: widget.chat.name
							),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.name,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    _typingUser!.containsValue(true) ? "${_typingUser.entries.where((entry) => entry.value).map((entry) => entry.key).firstOrNull} печатает..." : "${widget.chat.members.length} участника ${_onlineUsers.length != 0 ? ", ${_onlineUsers.length} онлайн" : ""}",
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

                      final dragOffset = _dragOffsets[index] ?? 0.0;

                      return (
                        Column(
                          key: ValueKey(index),
                          children: [
														GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onDoubleTap: () {
                                setState(() {

                                  print("ставим сердечко...");

                                  if(_messages[index].reactions == null) {
                                    _messages[index].reactions == [];
                                  }
                                  
                                  _service.addReaction(_messages[index].id, "❤️");
                                  
                                });
                              },
															onHorizontalDragUpdate: (d) {
																setState(() {
																  final newOffset = (dragOffset + d.delta.dx).clamp(-80, 0);
                                  _dragOffsets[index] = newOffset.toDouble();
																});
															},
															onHorizontalDragEnd: (_) {
																setState(() {
																	_dragOffsets[index] = 0;
																	_inputFocusNode.requestFocus();
                                  _replyTo = _messages[index];
                                  
																});
															},
															child: Transform.translate(
																offset: Offset(dragOffset, 0),
																child: MessageItem(message: _messages[index], roomType: widget.chat.type, isMe: _messages[index].userId == _userId, reactions: _messages[index].reactions, onEmojiTap: (Reaction reaction) {
                                  _service.deleteReaction(_messages[index].id, reaction.id);
                                }),
															)
														),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(_replyTo != null)
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.reply, color: Colors.blue),
                              onPressed: () {},
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "В ответ ${_replyTo!.userName}",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                Text(
                                  _replyTo!.body,
                                  style: TextStyle(
                                    color: Colors.grey.shade700
                                  )
                                )
                              ],
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.grey.shade700),
                              onPressed: () {
                                setState(() {
                                  _replyTo = null;
                                });
                              },
                            )
                          ],
                        )
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onEditingComplete: () {
                                FocusScope.of(context).nextFocus();
                            },
                            onChanged: _onTyping,
                            controller: _textContoller,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10
                              ),
                              isDense: true,
                              hintText: "Сообщение: ",
                              hintStyle: TextStyle(
                                fontSize: 14
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none
                              )
                            ),
                            focusNode: _inputFocusNode,
                            onSubmitted: _sendMessage,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () => _sendMessage(_textContoller.text),
                        )
                      ]
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