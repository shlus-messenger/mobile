import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shlus/api/api.dart';
import 'package:shlus/ui/screens/chat_list_screen.dart';
import 'package:shlus/ui/widgets/error.dart';
import 'package:shlus/ui/widgets/input.dart';

class AuthScreen extends StatefulWidget {

  final VoidCallback previousPage;
  final VoidCallback nextPage;

  const AuthScreen({
    super.key,
    required this.previousPage,
    required this.nextPage
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();

}

class _AuthScreenState extends State<AuthScreen> {

  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final PhoenixService _service = PhoenixService();
  bool _authError = false;

  Future<void> _entry() async {

    if(_loginController.text.trim() == "" || _passwordController.text.trim() == "") return;

    try {
      await _service.login(
        _loginController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => ChatListScreen()),
        (route) => false,
      );
    } on SocketException catch(_) {
        ErrorBanner.show(context, "Сервер недоступен");
    }
    catch (e) {
      ErrorBanner.show(context, "Неправильный логин или пароль");
      setState(() {
        _authError = true;
      });
    }
  }

  @override
  void initState() {

    super.initState();

    _loginController.addListener(() {
      setState(() {
        _authError = false;
      });
    });

    _passwordController.addListener(() {
      setState(() {
        _authError = false;
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
              Column(
                children: [
                  Text(
                    "Добро пожаловать в ",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Shlus Messenger",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w700,
                        fontSize: 24.sp
                      ),
                      children: [
                        TextSpan(
                          text: "!",
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700
                          )
                        )
                      ]
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Войдите в свой аккаунт чтобы продолжить",
                style: TextStyle(
                  color: Colors.grey.shade600
                ),
              ),
              const SizedBox(height: 50),
              Input(
                subscription: "Логин",
                placeholder: "Введите логин",
                prefixIcon: Icon(Icons.person_outline),
                controller: _loginController,
                hasError: _authError,
              ),
              const SizedBox(height: 20),
              Input(
                subscription: "Пароль",
                placeholder: "Введите пароль",
                prefixIcon: Icon(Icons.lock_outline),
                type: InputType.password,
                controller: _passwordController,
                hasError: _authError,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Забыли пароль?",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w700
                      )
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {await _entry();},
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.r)
                  ),
                  child: Text(
                    "Войти",
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
                    "Или войдите с помощью",
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
                  text: "Нет аккаунта? ",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: "Создать новый",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {widget.nextPage();}
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