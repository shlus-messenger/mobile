import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:shlus/models/chat.dart';
import 'package:shlus/api/api.dart';

class GroupInfoScreen extends StatefulWidget {

  final Chat chat;

  GroupInfoScreen({
    super.key,
    required this.chat
  });

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();

}

class _GroupInfoScreenState extends State<GroupInfoScreen> {

  final PhoenixService _service = PhoenixService();
  

  @override
  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {

            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.chat.logo),
                      radius: 50.r,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      widget.chat.name,
                      style: TextStyle(
                        fontSize: 24.sp
                      ),
                    ),
                    Text(
                      widget.chat.members.length.toString() + " участников",
                      style: TextStyle(
                        color: Colors.grey.shade500
                      )
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              spacing: 10.w,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.message_outlined),
                          Text(
                            "Message"
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_off_outlined),
                          Text(
                            "Unmute"
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.exit_to_app),
                          Text(
                            "Покинуть"
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}