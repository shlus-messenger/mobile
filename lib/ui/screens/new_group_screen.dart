import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shlus/api/api.dart';
import 'package:shlus/ui/screens/chat_list_screen.dart';
import 'package:shlus/ui/screens/chat_screen.dart';

class NewGroupScreen  extends StatefulWidget {

  const NewGroupScreen({super.key});

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();

}

class _NewGroupScreenState extends State<NewGroupScreen> {

  File? _selectedImage;
  PhoenixService _service = PhoenixService();
  TextEditingController _groupNameController = TextEditingController();

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
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () async {

          bool result = await _service.createGroup(_groupNameController.text, _selectedImage);

          if(result) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatListScreen()
              )
            );
          } 
        },
        child: Icon(Icons.check, color: Colors.white),
        shape: CircleBorder(),
        backgroundColor: Colors.blue,
      ),
      appBar: AppBar(
        title: Text(
          "Создать группу"
        )
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.25,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                        icon: Icon(Icons.add_a_photo),
                        onPressed: _pickImage,
                        color: Colors.white,
                      )
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: _groupNameController,
                      decoration: InputDecoration(
                        hintText: "Название группы",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.blue
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
              )
            )
          ],
        ),
      )
    );

  }

}