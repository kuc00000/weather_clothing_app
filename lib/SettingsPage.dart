import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'TimeSetting.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String pass = '';
  bool _switch1 = true;
  bool _switch2 = true;
  RangeValues _currentRangeValues = const RangeValues(0, 20);
  int currentPageIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.topRight,
            child: const Text(
              'sht06025 님   ',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
              height:0.8,
              width:500.0,
              color:Colors.black
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '   피드백 설정',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Transform.scale(
                      scale: 0.80,
                      child: CupertinoSwitch(
                        value: _switch1,
                        onChanged: (bool value) {
                          setState(() {
                            _switch1 = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              height:0.8,
              width:500.0,
              color:Colors.black
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '   피드백 알람 시간',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    CupertinoButton(
                      child: Text('10:00 pm'), // TimeSetting에서 저장한 값을 여기에 넣기, 저장값이 없으면 10:00 pm이 기본
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return TimeSetting(title: 'time setting result',);
                            }
                        );
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              height:0.8,
              width:500.0,
              color:Colors.black
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '   여성복 추천',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Transform.scale(
                      scale: 0.80,
                      child: CupertinoSwitch(
                        value: _switch2,
                        onChanged: (bool value) {
                          setState(() {
                            _switch2 = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              height:0.8,
              width:500.0,
              color:Colors.black
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '   체질 설정',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        thumbColor: Colors.white,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 11.0),
                        overlayColor: Colors.green.withOpacity(0.18),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0),
                        activeTrackColor: Color(0xFF34C759),
                        inactiveTrackColor: Colors.grey.shade300,
                        trackHeight: 11.0,
                        showValueIndicator: ShowValueIndicator.never,
                      ),
                      child: RangeSlider(
                        values: _currentRangeValues,
                        min: 0,
                        max: 20,
                        divisions: 4,
                        labels: RangeLabels(
                          _currentRangeValues.start.round().toString(),
                          _currentRangeValues.end.round().toString(),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _currentRangeValues = values;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          '추워요',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(
                          width: 45,
                        ),
                        const Text(
                          '보통',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(
                          width: 45,
                        ),
                        const Text(
                          '더워요',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              height:0.8,
              width:500.0,
              color:Colors.black
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '   내 옷장',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                TextButton(style: TextButton.styleFrom(foregroundColor: Colors.black),
                    onPressed: () {
                      setState(() {
                        Navigator.pushNamed(context, '/closet');
                      });
                    }, child: const Text('    >', style: TextStyle(fontSize: 18),)),
              ],
            ),
          ),
          Container(
              height:0.8,
              width:500.0,
              color:Colors.black
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '   로그아웃',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                TextButton(style: TextButton.styleFrom(foregroundColor: Colors.black),
                    onPressed: () {
                      setState(() {
                        Navigator.pushNamed(context, '/login');
                      });
                    }, child: const Text('    >', style: TextStyle(fontSize: 18))),
              ],
            ),
          ),
          Container(
              height:0.8,
              width:500.0,
              color:Colors.black
          ),
        ],
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