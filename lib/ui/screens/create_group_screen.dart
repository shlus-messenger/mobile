import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shlus/api/api.dart';

class CreateGroupScreen  extends StatefulWidget {

  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();

}

class _CreateGroupScreenState extends State<CreateGroupScreen> {

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

          bool result = await _service.createChat(_groupNameController.text, "group", _selectedImage);

          if(result) {
            Navigator.pop(context, true);
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