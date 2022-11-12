import 'package:flutter/material.dart';

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