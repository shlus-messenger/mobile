import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  String _message = "Добро пожаловать в ";

  void _changeMessage() {

    setState(() {
      _message = "Уже началось)";
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Главная"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Чат"),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: "База знаний"),
          BottomNavigationBarItem(icon: Icon(Icons.video_file), label: "Видео"),
      ]),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _message,
              style: const TextStyle(fontSize: 24, color: Colors.blue)
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _changeMessage, child: const Text("Начать")),
          ],
        )
      )
    );

  }

}