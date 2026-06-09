import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shlus/api/api.dart';

class CreateChannelScreen  extends StatefulWidget {

  const CreateChannelScreen({super.key});

  @override
  State<CreateChannelScreen> createState() => _CreateGroupScreenState();

}

class _CreateGroupScreenState extends State<CreateChannelScreen> {

  File? _selectedImage;
  final PhoenixService _service = PhoenixService();
  final TextEditingController _channelNameController = TextEditingController();
  final TextEditingController _channelDescriptionController = TextEditingController();

  Future<void> _pickImage() async {

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if(image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Создать канал"
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              bool result = await _service.createChat(_channelNameController.text, "channel", _selectedImage, description: _channelDescriptionController.text);

              if(result) {
                Navigator.pop(context, true);
              } 
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                      icon: Icon(Icons.add_a_photo, size: 25),
                      onPressed: _pickImage,
                      color: Colors.white,
                    )
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: _channelNameController,
                    decoration: InputDecoration(
                      hintText: "Название канала",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blue
                        )
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey.shade300
                        )
                      ),
                      focusColor: Colors.blue,
                      suffixIcon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.grey.shade500
                      )
                    ),
                    autofocus: true,
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _channelDescriptionController,
              decoration: InputDecoration(
                hintText: "Описание",
                hintStyle: TextStyle(
                  color: Colors.grey.shade500
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.blue
                  )
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.grey.shade300
                  )
                ),
                focusColor: Colors.blue
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    "Можете указать дополнительное описание канала",
                    style: TextStyle(
                      color: Colors.grey.shade700
                    ),
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}