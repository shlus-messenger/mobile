import 'package:flutter/material.dart';
import 'package:shlus/ui/screens/profile_screen.dart';
import 'package:shlus/ui/screens/settings_screen.dart';
import 'chat_screen.dart';

class MainScreen extends StatefulWidget {

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen> {

  int _selectedIndex = 0;

  final List<Widget> _screens = [

    const ChatScreen(),
    const SettingsScreen(),
    const ProfileScreen()

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Чаты"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Настройки"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Профиль"),
      ])
    );
    
  }

}