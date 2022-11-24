import 'package:flutter/material.dart';

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
    final args = ModalRoute.of(context)?.settings.arguments as Map;
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
                Navigator.pushNamed(context, '/select',arguments:{'temp':args['temp'],'feels_like':args['feels_like'],'pm10':args['pm10'],'pm2_5':args['pm2_5'],'pop':args['pop']});
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