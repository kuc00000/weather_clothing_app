import 'package:flutter/material.dart';

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
            TextButton(style: TextButton.styleFrom(foregroundColor: Colors.black),
                onPressed: () {
                  setState(() {
                    Navigator.pushNamed(context, '/settings');
                  });
                }, child: const Text('설정화면', style: TextStyle(fontSize: 15),)),
          ],
        ),
      ),
    );
  }
}