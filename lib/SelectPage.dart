import 'package:flutter/material.dart';

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
                //backgroundColor: Colors.grey
            ),
                child: const Text('옷 추가 완료')
            ),
          ],
        ),
      ),
    );
  }
}