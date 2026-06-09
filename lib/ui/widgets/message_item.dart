import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shlus/models/message.dart';
import 'package:shlus/models/reaction.dart';
import 'package:shlus/ui/widgets/logo.dart';

class MessageItem extends StatelessWidget {

  final Message message;
  final bool isMe;
  final String roomType;
  final List<Reaction>? reactions;
  final Function? onEmojiTap;

  const MessageItem({
    super.key,
    required this.message,
    required this.isMe,
    required this.roomType,
    this.reactions,
    this.onEmojiTap
  });


  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if(!isMe) _buildAvatar(),
          if(!isMe) const SizedBox(width: 10),
          _buildMessageBubble(context),
          if(isMe) const SizedBox(width: 10),
          if(isMe) _buildAvatar(),
        ]
      )
    );
  }

  Widget _buildMessageBubble(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: isMe ? Color.fromARGB(255, 192, 232, 199) : Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10, left: 10),
      child: IntrinsicWidth(
            child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    if(!isMe && roomType != "dialog") Text(
                      message.userName,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w800
                      )
                    ),

                    if(message.replyTo != null) ...[
                      _buildReplyPreview()
                    ],

                    Text(
                      message.body,

                      softWrap: true,
                    ),

                    const SizedBox(height: 4),

                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if(reactions != [])
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: reactions!.map((reaction) => GestureDetector(
                              onTap: () {
                                onEmojiTap!(reaction);
                              },
                              child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    reaction.emoji,
                                    style: TextStyle(
                                      color: Colors.red
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: const Offset(5, 0),
                                    child: Logo(
                                      logo: "http://10.0.2.2:8333/chats/f88ae209-1fa9-4eb7-8ecd-831bba611f13/logo/logo.png",
                                      name: "Mark",
                                      radius: 10,
                                      
                                    ),
                                  )
                                ],
                              )
                            )),
                            ).toList()
                          ),
                        const SizedBox(width: 20),
                        Text(
                          "${message.date.hour}:${message.date.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
        )
    );

  }

  Widget _buildAvatar() {

    return Logo(
      logo: message.avatar,
      name: "Mark",
    );

  }

  Widget _buildReplyPreview() {

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border(
          left: BorderSide(
            color: Color.fromARGB(255, 129, 176, 138),
            width: 4
          )
        ),
        color: Color.fromARGB(255, 186, 217, 192),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.replyTo!.userName,
            style: TextStyle(
              color: Color.fromARGB(255, 37, 180, 63),
            )
          ),
          Text(
            message.replyTo!.body,
            style: TextStyle(
              color: Colors.grey.shade500
            )
          ),
        ],
      ),
    );
  }
}