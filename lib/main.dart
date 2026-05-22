import 'package:flutter/material.dart';
import 'package:shlus/ui/screens/chat_screen.dart';
import 'package:shlus/ui/screens/main_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("ru_RU", null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "",

      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)
      ),

      home: const MainScreen()
    );

  }

}