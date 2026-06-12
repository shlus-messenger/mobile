import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if(!isMe) _buildAvatar(),
          if(!isMe) SizedBox(width: 10.w),
          _buildMessageBubble(context),
          if(isMe) SizedBox(width: 10.w),
          if(isMe) _buildAvatar(),
        ]
      )
    );
  }

  Widget _buildMessageBubble(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: isMe ? Color.fromARGB(255, 192, 232, 199) : Colors.white,
        borderRadius: BorderRadius.circular(10.r)
      ),
      padding: EdgeInsets.only(right: 10.w, top: 10.h, bottom: 10.h, left: 10.w),
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

                    SizedBox(height: 4.h),

                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if(reactions != [])
                          Wrap(
                            spacing: 4.w,
                            runSpacing: 4.h,
                            children: reactions!.map((reaction) => GestureDetector(
                              onTap: () {
                                onEmojiTap!(reaction);
                              },
                              child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
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
                                    offset: Offset(5.w, 0),
                                    child: Logo(
                                      logo: "http://10.0.2.2:8333/chats/f88ae209-1fa9-4eb7-8ecd-831bba611f13/logo/logo.png",
                                      name: "Mark",
                                      radius: 10.r,
                                      
                                    ),
                                  )
                                ],
                              )
                            )),
                            ).toList()
                          ),
                        SizedBox(width: 20.w),
                        Text(
                          "${message.date.hour}:${message.date.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            fontSize: 11.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        border: Border(
          left: BorderSide(
            color: Color.fromARGB(255, 129, 176, 138),
            width: 4.w
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