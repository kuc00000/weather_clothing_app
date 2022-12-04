import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  String pass = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset(
          'appbar.png',
          height: 45,
        ),
        actions: [
          /* 로그아웃 코드 -> 그냥 옷장 종료 */
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.clear,
            color: Colors.black54,size: 30,))
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
                Navigator.pushNamed(context, '/closet');
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