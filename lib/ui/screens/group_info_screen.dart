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
        padding: EdgeInsets.symmetric(horizontal: 20),
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
                      radius: 50,
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.chat.name,
                      style: TextStyle(
                        fontSize: 24
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
            SizedBox(height: 20),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
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
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
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
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
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