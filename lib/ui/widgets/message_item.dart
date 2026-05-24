import 'package:flutter/material.dart';
import 'package:shlus/models/message.dart';

class MessageItem extends StatelessWidget {

  final Message message;

  const MessageItem({
    super.key,
    required this.message
  });

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Image.network("http://localhost:9333/bucket/users/${message.userId}"),
          const SizedBox(width: 8),

          Expanded(
            child: Column(
              children: [
                Text(
                  message.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.w500
                  )
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          message.body
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      )
    );
  }
}