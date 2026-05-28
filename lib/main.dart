import 'package:flutter/material.dart';
import 'package:shlus/ui/screens/main_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {

    FlutterError.presentError(details);

    log(
      details.exceptionAsString(),
      stackTrace: details.stack,
      name: "FlutterError"
    );

  };

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