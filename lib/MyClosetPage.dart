import 'package:flutter/material.dart';

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