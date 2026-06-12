import 'package:flutter/material.dart';
import 'package:shlus/ui/screens/auth_screen.dart';
import 'package:shlus/ui/screens/create_account_screen.dart';
import 'package:shlus/ui/screens/hello_screen.dart';

class EntryScreen extends StatefulWidget {

  const EntryScreen({
    super.key
  });

  @override
  State<EntryScreen> createState() => _EntryScreenState();

}

class _EntryScreenState extends State<EntryScreen> {

  final PageController _pageController = PageController();

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }

  @override
  Widget build(BuildContext context){
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        //HelloScreen(nextPage: _nextPage),
        AuthScreen(previousPage: _previousPage, nextPage: _nextPage),
        CreateAccountScreen(previousPage: _previousPage)
      ],
    );
  }

}