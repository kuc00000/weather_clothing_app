import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// 페이지
import 'MyHomePage.dart';
import 'AddPage.dart';
import 'SelectPage.dart';
import 'MyClosetPage.dart';
import 'MainPage.dart';
import 'CalendarPage.dart';
import 'SettingsPage.dart';
import 'LoginPage.dart';
import 'SignupPage.dart';
import 'UserInfomation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context)=>Users(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: buildMaterialColor(const Color(0xff78E2DF)),
        ),
        initialRoute: '/',
        routes: {
          // 로딩화면은 splash 이용해 구현 -> 이미지 파일만 있으면 됨
          // 로딩화면 -> 동네 설정 화면 바로 나오면 안 되고, 로그인화면 먼저 나와야 할 듯
          // 최초 로그인일 경우에만 동네 설정 화면 띄우기
          // 이 기능이 어렵다면, 동네 설정 화면은 제거하고 홈화면에서 gps 버튼 눌러 설정할 수 있도록 함
          '/': (context) => const LoginPage(),
          '/location': (context) => const MyHomePage(title: 'Location',),
          '/add': (context) => const AddPage(title: 'Add Cloth',),
          '/select': (context) => const SelectPage(title: 'Select Closet',),
          '/closet': (context) => const MyClosetPage(title: 'My Closet',),
          '/main': (context) => const MainPage(title: 'Main',),
          '/calendar': (context) => const CalendarPage(title: 'Calendar',),
          '/settings': (context) => const SettingsPage(title: 'Settings',),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
        },
      ),
    );
  }
}
