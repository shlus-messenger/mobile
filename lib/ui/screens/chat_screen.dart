import 'package:flutter/material.dart';
import 'package:shlus/models/chat.dart';
import 'package:shlus/api/api.dart';
import 'package:shlus/models/message.dart';
import 'package:shlus/ui/widgets/message_item.dart';

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

  @override
  void initState() {

    super.initState();

    _service.onNewMessage = (payload) {

      setState(() {

        final newMessage = Message.fromJson(payload);
        _messages.add(newMessage);

      });

    };

    _service.initChannel(
      widget.chat.id,
      "a97f852a-0f86-462f-8814-f119d755cdb1",
      "Mark"
    );

    Future.delayed(Duration(milliseconds: 500), () {

      _service.joinToChannel(

        widget.chat.id,
        "a97f852a-0f86-462f-8814-f119d755cdb1",
        "Mark"

      );

      _loadMessages();

    });

  }

  void _loadMessages() async {

    try {

      final messages = await _service.getMessages(

        widget.chat.id,
        "a97f852a-0f86-462f-8814-f119d755cdb1"

      );

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

    _service.sendMessage(

      widget.chat.id,
      "a97f852a-0f86-462f-8814-f119d755cdb1",
      "Mark",
      text

    );  
  }

  @override
  void dispose() {

    _textContoller.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.grey,
        elevation: 1,
        title: Column(
          children: [
            Text(
              widget.chat.name,
              textAlign: TextAlign.left,
            ),
            Text(
              "был(а) недавно",
              style: TextStyle(
                fontSize: 12
              ),
            )
          ],
        )
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(left: 20, top: 20),
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return MessageItem(message: _messages[index]);
                    },
                  )
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textContoller,
                      decoration: InputDecoration(
                        hintText: "Сообщение: ",
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
          ],
        )
      )
    );
  }
}