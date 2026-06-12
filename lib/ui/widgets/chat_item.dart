import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:shlus/models/chat.dart';
import 'package:intl/intl.dart';

import 'package:shlus/ui/widgets/logo.dart';

class ChatItem extends StatelessWidget {
  
  final Chat chat;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  const ChatItem({
    super.key,
    required this.chat,
    this.onTap,
    this.onLongPress,
    this.isSelected = false
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
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Logo(
                  logo: chat.logo,
                  name: chat.name
                ),
                if(isSelected) ...[
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      alignment: Alignment.center,
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(50.r)
                      ),
                      child: Icon(Icons.check, color: Colors.white, size: 20.sp),
                    ),
                  )
                ]
              ],
            ),
            SizedBox(width: 12.w),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  if(chat.lastMessage != null)

                    Text(
                      chat.type == "group" ? "${chat.lastMessageUserName ?? ''}: ${chat.lastMessage ?? ''}" : chat.lastMessage ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
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
                  fontSize: 12.sp,
                  color: Colors.grey.shade500,
                ),
              ),
          ],
        ),
      ),
    );

  }

}