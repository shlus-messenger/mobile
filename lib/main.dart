import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shlus/api/api.dart';
import 'package:shlus/ui/screens/entry_screen.dart';
import 'package:shlus/ui/screens/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  await ScreenUtil.ensureScreenSize();
  await dotenv.load(fileName: ".env");

  final service = PhoenixService();
  await service.initData();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(412, 915),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        title: "",

        theme: ThemeData(
          primarySwatch: Colors.red,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)
        ),
        
        home: FutureBuilder(
          future: _checkAuth(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator())
              );
            }

            else if(snapshot.hasData && snapshot.data == true) {
              return const HomeScreen();
            }

            else{
              return const EntryScreen();
            }
          }
        )
      ),
    );

  }

  Future<bool> _checkAuth() async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.get("token");
    final userId = prefs.get("userId");
    final userName= prefs.get("userName");

    return token != null && userId != null && userName != null;

  }

}