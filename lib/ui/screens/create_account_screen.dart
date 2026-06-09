import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shlus/api/api.dart';
import 'package:shlus/ui/screens/chat_list_screen.dart';
import 'package:shlus/ui/widgets/input.dart';

class CreateAccountScreen extends StatefulWidget {

  final VoidCallback previousPage;

  const CreateAccountScreen({
    super.key,
    required this.previousPage
  });

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();

}

class _CreateAccountScreenState extends State<CreateAccountScreen> {

  final PageController _pageController = PageController();
  String login = "";
  String password = "";

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,

    );
  }

  @override
  Widget build(BuildContext context) {

    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        LoginAndPassword(previousPage: widget.previousPage, nextPage: _nextPage, onDataChange: (login, password) {
          setState(() {
            this.login = login;
            this.password = password;
          });
        }),
        AvatarAndName(previousPage: _previousPage, login: login, password: password)
      ],
    );
  }
}

class LoginAndPassword extends StatefulWidget {

  final VoidCallback previousPage;
  final VoidCallback nextPage;
  final Function(String login, String password) onDataChange;

  const LoginAndPassword({
    super.key,
    required this.previousPage,
    required this.nextPage,
    required this.onDataChange
  });

  @override
  State<LoginAndPassword> createState() => _LoginAndPasswordState();

}

class _LoginAndPasswordState extends State<LoginAndPassword> {

  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmedPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 18,
          style: ButtonStyle(
            
          ),
          onPressed: widget.previousPage,
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/icons/logo.svg",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              Text(
                "Создание аккаунта",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Заполните информацию, чтобы начать",
                style: TextStyle(
                  color: Colors.grey.shade600
                ),
              ),
              const SizedBox(height: 50),
              Input(
                subscription: "Логин",
                placeholder: "Придумайте логин",
                prefixIcon: Icon(Icons.person_outline),
                controller: _loginController,
              ),
              const SizedBox(height: 20),
              Input(
                subscription: "Пароль",
                placeholder: "Придумайте пароль",
                prefixIcon: Icon(Icons.lock_outline),
                type: InputType.password,
                controller: _passwordController,
              ),
              const SizedBox(height: 20),
              Input(
                subscription: "Подтвердите пароль",
                placeholder: "Подтвердите пароль",
                prefixIcon: Icon(Icons.lock_outline),
                type: InputType.password,
                controller: _confirmedPasswordController,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  widget.onDataChange(_loginController.text, _passwordController.text);
                  widget.nextPage();
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                    "Далее",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)
                  )
                )
              ),
              const SizedBox(height: 20),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey.shade400
                    )
                  ),
                  Text(
                    "Или зарегистрируйтесь с помощью",
                    style: TextStyle(
                      color: Colors.grey.shade500
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey.shade400
                    )
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 30,
                children: [
                  ...[
                    {"icon": Icon(Icons.g_mobiledata), "title": "Google"},
                    {"icon": Icon(Icons.apple), "title": "Apple"},
                    {"icon": Icon(Icons.pets), "title": "Github"}
                  ].map((variant) => entryVariantButton(variant["icon"] as Icon, variant["title"] as String))
                ],
              ),
              const SizedBox(height: 30),
              Text.rich(
                TextSpan(
                  text: "Уже есть аккаунт? ",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: "Войти",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.previousPage
                    )
                  ]
                )
              )
            ]
          )
        ),
      ),
    );
  }

  Widget entryVariantButton(Icon icon, String title) {

    return InkWell(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(
              title
            )
          ],
        ),
      ),
    );

  }
}

class AvatarAndName extends StatefulWidget {

  final VoidCallback previousPage;
  final String login;
  final String password;

  const AvatarAndName({
    super.key,
    required this.previousPage,
    required this.login,
    required this.password
  });

  @override
  State<AvatarAndName> createState() => _AvatarAndName();

}

class _AvatarAndName extends State<AvatarAndName> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final PhoenixService _service = PhoenixService();
  File? _selectedImage;

  Future<void> _createAccount() async {

    final result = await _service.createAccount(_nameController.text, widget.login, widget.password, _aboutMeController.text, _selectedImage);
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => ChatListScreen()
      ),
      (route) => false
    );
    
  }

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
        leading: IconButton(
          iconSize: 18,
          style: ButtonStyle(
            
          ),
          onPressed: widget.previousPage,
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/icons/logo.svg",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              Text(
                "Создание аккаунта",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Заполните информацию, чтобы начать",
                style: TextStyle(
                  color: Colors.grey.shade600
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _pickImage,
                        child: CircleAvatar(
                          backgroundColor: Color(0xFFEAE7F2),
                          backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                          radius: 40,
                          child: _selectedImage == null ? Icon(Icons.person_outlined, size: 50, color: Colors.grey) : null,
                        ),
                      ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: Container(
                          alignment: Alignment.center,
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue
                          ),
                          child: Icon(Icons.photo_camera, color: Colors.white, size: 15),
                        ),
                      )
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Выбрать аватар",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  )
                ],
              ),
              Input(
                subscription: "Имя",
                placeholder: "Придумайте себе имя",
                prefixIcon: Icon(Icons.person_outline),
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              Input(
                subscription: "О себе",
                placeholder: "Напишите что-нибудь о себе",
                prefixIcon: Icon(Icons.edit_outlined),
                controller: _aboutMeController,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {await _createAccount();},
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color.from(alpha: 1, red: 0.129, green: 0.588, blue: 0.953),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                    "Создать аккаунт",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)
                  )
                )
              ),
              const SizedBox(height: 20),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey.shade400
                    )
                  ),
                  Text(
                    "Или зарегистрируйтесь с помощью",
                    style: TextStyle(
                      color: Colors.grey.shade500
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey.shade400
                    )
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 30,
                children: [
                  ...[
                    {"icon": Icon(Icons.g_mobiledata), "title": "Google"},
                    {"icon": Icon(Icons.apple), "title": "Apple"},
                    {"icon": Icon(Icons.pets), "title": "Github"}
                  ].map((variant) => entryVariantButton(variant["icon"] as Icon, variant["title"] as String))
                ],
              ),
              const SizedBox(height: 30),
              Text.rich(
                TextSpan(
                  text: "Уже есть аккаунт? ",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: "Войти",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.previousPage
                    )
                  ]
                )
              )
            ]
          )
        ),
      ),
    );
  }

  Widget entryVariantButton(Icon icon, String title) {

    return InkWell(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(
              title
            )
          ],
        ),
      ),
    );
  }

}