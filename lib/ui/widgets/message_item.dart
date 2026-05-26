import 'package:flutter/material.dart';
import 'package:shlus/models/message.dart';
import 'dart:math';

class MessageItem extends StatelessWidget {

  final Message message;
  final bool isMe;

  const MessageItem({
    super.key,
    required this.message,
    required this.isMe
  });

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: isMe 
          ? [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 192, 232, 199),
                  borderRadius: BorderRadius.circular(10)
                ),
                padding: const EdgeInsets.only(right: 30, top: 10, bottom: 10, left: 10),
                child: Text(
                    message.body,
                    softWrap: true,
                )
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundImage: NetworkImage("http://10.0.2.2:8333/chats/f88ae209-1fa9-4eb7-8ecd-831bba611f13/logo/logo.png"),
              radius: 25,
            ),
          ] 
          : [
            CircleAvatar(
              backgroundImage: NetworkImage("http://10.0.2.2:8333/chats/f88ae209-1fa9-4eb7-8ecd-831bba611f13/logo/logo.png"),
              radius: 25,
            ),
            const SizedBox(width: 8),

            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.userName,
											style: TextStyle(
												fontWeight: FontWeight.w500,
												color: Color.fromARGB(255, Random().nextInt(256), Random().nextInt(256), Random().nextInt(256))
											)
                    ),
                    const SizedBox(height: 10),
                    Text(
                      message.body,
                      softWrap: true,
                    )
                  ],
                )
              ),
            ),
          ],
      )
    );
  }
}