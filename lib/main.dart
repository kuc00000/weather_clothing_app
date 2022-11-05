import 'package:flutter/material.dart';

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
        '/': (context) => const MyHomePage(title: 'Location',),
        '/add': (context) => const AddPage(title: 'Add Cloth',),
        '/select': (context) => const SelectPage(title: 'Select Closet',),
        '/closet': (context) => const MyClosetPage(title: 'My Closet',),
        '/main': (context) => const MainPage(title: 'Main',),
        //'/settings': (context) => const SettingsPage(title: 'Settings',),
        //'/login': (context) => const LoginPage(title: 'Login',),
        //'/signup': (context) => const SignupPage(title: 'Signup',),
        '/result': (context) => const ResultPage(title: 'Result',),
      },
      // home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pass = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '우리 동네를 검색해 찾아보세요',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '국내 동/면/읍을 입력해주세요 ex) 상도동',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const Text(
              '동네의 날씨와 추천 옷차림을 볼 수 있어요',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () {
              setState(() {
                Navigator.pushNamed(context, '/add');
              });
            }, child: const Text('Next')),
          ],
        ),
      ),
    );
  }
}

class AddPage extends StatefulWidget {
  const AddPage({super.key, required this.title});

  final String title;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  String pass = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '카테고리별 옷을 추가해주세요!',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '본인의 옷을 카테고리에 맞게 추가해주세요',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              '추천 옷차림을 카테고리에 맞게 알려드려요',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () {
              setState(() {
                Navigator.pushNamed(context, '/select');
              });
            },style: ElevatedButton.styleFrom(
              minimumSize: const Size(40,40),
              // backgroundColor: Colors.grey,
              // 나중에 color 좀 더 연하게 바꾸기
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
            ),
                child: const Text('+')),
          ],
        ),
      ),
    );
  }
}

class SelectPage extends StatefulWidget {
  const SelectPage({super.key, required this.title});

  final String title;

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {

  String pass = '';

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '원하는 옵션을 선택해주세요',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {
                  setState(() {
                    pass = '반팔';
                    Navigator.pushNamed(context, '/result', arguments: pass);
                  });
                }, style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120,120),
                    textStyle: const TextStyle(fontSize: 15),
                    backgroundColor: Colors.white),
                    child: const Text('상의-반팔')
                ),
                ElevatedButton(onPressed: () {
                  setState(() {
                    pass = '긴팔';
                    Navigator.pushNamed(context, '/result', arguments: pass);
                  });
                }, style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120,120),
                    textStyle: const TextStyle(fontSize: 15),
                    backgroundColor: Colors.white),
                    child: const Text('상의-긴팔')
                ),
                ElevatedButton(onPressed: () {
                  setState(() {
                    pass = '원피스';
                    Navigator.pushNamed(context, '/result', arguments: pass);
                  });
                }, style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120,120),
                    textStyle: const TextStyle(fontSize: 15),
                    backgroundColor: Colors.white),
                    child: const Text('원피스')
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {
                  setState(() {
                    pass = '아우터';
                    Navigator.pushNamed(context, '/result', arguments: pass);
                  });
                }, style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120,120),
                    textStyle: const TextStyle(fontSize: 15),
                    backgroundColor: Colors.white),
                    child: const Text('아우터')
                ),
                ElevatedButton(onPressed: () {
                  setState(() {
                    pass = '팬츠';
                    Navigator.pushNamed(context, '/result', arguments: pass);
                  });
                }, style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120,120),
                    textStyle: const TextStyle(fontSize: 15),
                    backgroundColor: Colors.white),
                    child: const Text('팬츠')
                ),
                ElevatedButton(onPressed: () {
                  setState(() {
                    pass = '스커트';
                    Navigator.pushNamed(context, '/result', arguments: pass);
                  });
                }, style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120,120),
                    textStyle: const TextStyle(fontSize: 15),
                    backgroundColor: Colors.white),
                    child: const Text('스커트')
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () {
              setState(() {
                Navigator.pushNamed(context, '/main', arguments: pass);
              });
            }, style: ElevatedButton.styleFrom(
                minimumSize: const Size(385,40),
                textStyle: const TextStyle(fontSize: 15),
                backgroundColor: Colors.grey),
                child: const Text('옷 추가 완료')
            ),
          ],
        ),
      ),
    );
  }
}

class MyClosetPage extends StatefulWidget {
  const MyClosetPage({super.key, required this.title});

  final String title;

  @override
  State<MyClosetPage> createState() => _MyClosetPageState();
}

class _MyClosetPageState extends State<MyClosetPage> {

  String pass = '';

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '상의-반팔 옷장',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            ElevatedButton(onPressed: () {
              setState(() {
                Navigator.pushNamed(context, '/select', arguments: pass);
              });
            }, style: ElevatedButton.styleFrom(
                minimumSize: const Size(385,40),
                textStyle: const TextStyle(fontSize: 15),
                backgroundColor: Colors.grey),
                child: const Text('완료')
            ),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  String pass = '';

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '오늘의 추천',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '주간날씨',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.title});

  final String title;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  String pass = '';

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '10월',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '비슷한 날씨일 때의 옷차림과 피드백만 보기',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.title});

  final String title;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '당신의 선택은',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(args,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}