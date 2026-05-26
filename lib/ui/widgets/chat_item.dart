import 'package:flutter/material.dart';
import 'package:shlus/models/chat.dart';
import 'package:intl/intl.dart';

class ChatItem extends StatelessWidget {
  
  final Chat chat;
  final VoidCallback? onTap;

  const ChatItem({
    super.key,
    required this.chat,
    this.onTap
  });

  String _formatDate(DateTime date) {

    final now = DateTime.now();
    final diff = now.difference(date);

    if(diff.inDays == 0) {

      return '${date.hour.toString()}:${date.minute.toString()}';

    }

    else if(diff.inDays == 1) {

      return "Вчера";

    }

    else {
      
      return DateFormat('d MMMM', 'ru').format(date);

    }
  }

  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(chat.logoUrl),
            ),
            const SizedBox(width: 12),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 4),

                  if(chat.lastMessage != null)

                    Text(
                      chat.type == "group" ? "${chat.lastMessageUserName ?? ''}: ${chat.lastMessage ?? ''}" : chat.lastMessage ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),

            if(chat.lastMessage != null)

              Text(
                _formatDate(chat.lastMessageAt!),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
          ],
        ),
      ),
    );

  }

}