import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shlus/api/api.dart';
import 'package:shlus/ui/screens/chat_list_screen.dart';
import 'package:shlus/ui/widgets/error.dart';
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
        AvatarAndName(previousPage: _previousPage, login: "@$login", password: password)
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
  bool _arePasswordsDontMatchError = false;
  bool _loginError = false;
  final PhoenixService _service = PhoenixService();

  @override
  void initState() {

    super.initState();

    _confirmedPasswordController.addListener(() {
      setState(() {
        _arePasswordsDontMatchError = _confirmedPasswordController.text != "" && !(_passwordController.text == _confirmedPasswordController.text);
      });
    });

    _loginController.addListener(() {
      setState(() {
        _loginError = false;
      });
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 18.sp,
          style: ButtonStyle(
            
          ),
          onPressed: widget.previousPage,
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Center(
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/icons/logo.svg",
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
              ),
              Text(
                "Создание аккаунта",
                style: TextStyle(
                  fontSize: 24.sp,
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
                hasError: _loginError,
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
                hasError: _arePasswordsDontMatchError,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  if(!_arePasswordsDontMatchError && _passwordController.text != "" && _loginController.text != "" && _confirmedPasswordController.text != "") {
                    if(!(await _service.isUserExist(_loginController.text))) {
                      widget.onDataChange(_loginController.text, _passwordController.text);
                      widget.nextPage();
                    }
                    else {
                      setState(() {
                        _loginError = true;
                      });
                      ErrorBanner.show(context, "Логин занят");
                    }
                  }
                  else if(_arePasswordsDontMatchError){
                    ErrorBanner.show(context, "Пароли не совпадают");
                  }
                  else {
                    ErrorBanner.show(context, "Пожалуйста, заполните все поля");
                  }
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.r)
                  ),
                  child: Text(
                    "Далее",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600)
                  )
                )
              ),
              const SizedBox(height: 20),
              Row(
                spacing: 10.w,
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
                spacing: 30.w,
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
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
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
  bool _nameError = false;

  Future<void> _createAccount() async {

    try {
      final result = await _service.createAccount(_nameController.text, widget.login, widget.password, _aboutMeController.text, _selectedImage);
    
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => ChatListScreen()
        ),
        (route) => false
      );
    }
    catch(e) {
      if(e == "User already exists") {
        
      }
    }
    
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
  void initState() {

    super.initState();

    _nameController.addListener(() {
      setState(() {
        _nameError = false;
      });
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 18.sp,
          style: ButtonStyle(
            
          ),
          onPressed: widget.previousPage,
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Center(
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/icons/logo.svg",
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
              ),
              Text(
                "Создание аккаунта",
                style: TextStyle(
                  fontSize: 24.sp,
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
                          radius: 40.r,
                          child: _selectedImage == null ? Icon(Icons.person_outlined, size: 50.sp, color: Colors.grey) : null,
                        ),
                      ),
                      Positioned(
                        bottom: -5.h,
                        right: -5.w,
                        child: Container(
                          alignment: Alignment.center,
                          width: 25.w,
                          height: 25.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue
                          ),
                          child: Icon(Icons.photo_camera, color: Colors.white, size: 15.sp),
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
                hasError: _nameError,
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
                onTap: () async {
                  if(!(_nameController.text == "")) {
                    await _createAccount();
                  }
                  else {
                    setState(() {
                      _nameError = true;
                    });
                    ErrorBanner.show(context, "Введите имя");
                  }
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  decoration: BoxDecoration(
                    color: const Color.from(alpha: 1, red: 0.129, green: 0.588, blue: 0.953),
                    borderRadius: BorderRadius.circular(10.r)
                  ),
                  child: Text(
                    "Создать аккаунт",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600)
                  )
                )
              ),
              const SizedBox(height: 20),
              Row(
                spacing: 10.w,
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
                spacing: 30.w,
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
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
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