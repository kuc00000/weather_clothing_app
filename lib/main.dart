import 'package:flutter/material.dart';
import 'MyHomePage.dart';
import 'AddPage.dart';
import 'SelectPage.dart';
import 'MyClosetPage.dart';
import 'MainPage.dart';
import 'CalendarPage.dart';
import 'SettingsPage.dart';
import 'LoginPage.dart';
import 'SignupPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      initialRoute: '/',
      routes: {
        // 로딩화면은 splash 이용해 구현 -> 이미지 파일만 있으면 됨
        // 로딩화면 -> 동네 설정 화면 바로 나오면 안 되고, 로그인화면 먼저 나와야 할 듯
        // 최초 로그인일 경우에만 동네 설정 화면 띄우기
        // 이 기능이 어렵다면, 동네 설정 화면은 제거하고 홈화면에서 gps 버튼 눌러 설정할 수 있도록 함
        '/': (context) => const LoginPage(title: 'Login',),
        '/location': (context) => const MyHomePage(title: 'Location',),
        '/add': (context) => const AddPage(title: 'Add Cloth',),
        '/select': (context) => const SelectPage(title: 'Select Closet',),
        '/closet': (context) => const MyClosetPage(title: 'My Closet',),
        '/main': (context) => const MainPage(title: 'Main',),
        '/calendar': (context) => const CalendarPage(title: 'Calendar',),
        '/settings': (context) => const SettingsPage(title: 'Settings',),
        '/login': (context) => const LoginPage(title: 'Login',),
        '/signup': (context) => const SignupPage(title: 'Signup',),
      },
    );
  }
}
