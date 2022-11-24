import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {


  String pass = '';
  String locationDropdownValue = '암사동';
  int currentPageIndex = 0;

  @override

  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    final pop = args['pop'];
    final pm10 = args['pm10'];
    final pm2_5 = args['pm2_5'];
    final temp = args['temp'];
    final feels_like = args['feels_like'];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          itemHeight: 48,
                          borderRadius: BorderRadius.circular(5),
                          underline: SizedBox(),
                          icon: const Icon(Icons.location_on_outlined),
                          iconSize: 23,
                          value: locationDropdownValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              locationDropdownValue = newValue!;
                            });
                          },
                          items: <String>['암사동','상도동','동네추가'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 50,
                ),
                Row(
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      child: Center(child: Text('우'),),
                      decoration: BoxDecoration(
                        color: const Color(0xffCFE7EE),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                     Text(
                      '강수확률 $pop%',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 25,
                      height: 25,
                      child: Center(child: Text('마'),),
                      decoration: BoxDecoration(
                        color: const Color(0xffC0D1FD),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                     Text(
                      '미세먼지 $pm10',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('날씨 그림'),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$temp℃',
                        style: TextStyle(fontSize: 40,),
                      ),
                      Text(
                        '체감온도 $feels_like ℃',
                        style: TextStyle(fontSize: 14,),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '맨투맨 입기에는 덥지만',
                        style: TextStyle(fontSize: 14,),
                      ),
                      Text(
                        '반팔, 가디건은 괜찮은 날씨',
                        style: TextStyle(fontSize: 14,),
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: const Color(0xffE3EDEE),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  '오늘의 추천',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.arrow_back_ios_sharp, size: 40,),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('그림'),
                        const SizedBox(
                          width: 20,
                        ),
                        Text('트위드 자켓'),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('그림'),
                        const SizedBox(
                          width: 20,
                        ),
                        Text('가죽치마'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Icon(Icons.arrow_forward_ios_sharp, size: 40,),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 0.3,
              color: Colors.black,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  '주간날씨',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  '수',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Text(
                  '날씨그림',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '20~24℃',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const Text(
                      '반팔 티셔츠, 가디건',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  '목',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Text(
                  '날씨그림',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '20~24℃',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const Text(
                      '반팔 티셔츠, 가디건',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  '금',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Text(
                  '날씨그림',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '20~24℃',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const Text(
                      '반팔 티셔츠, 가디건',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
            if (index == 0) {
              Navigator.pushNamed(context, '/main');
            } else if (index == 1) {
              Navigator.pushNamed(context, '/calendar');
            } else {
              Navigator.pushNamed(context, '/settings');
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: '캘린더',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: '설정',
          ),
        ],
        selectedItemColor: Colors.lightBlue,
      ),
    );
  }
}