import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'TimeSetting.dart';
import 'UserInfomation.dart';

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
  static final storage = FlutterSecureStorage();
  final _authentication = FirebaseAuth.instance;
  String? UserInfo='';
  String? UserId='';
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _asyncMethod();
    });
  }
  _asyncMethod() async {
    UserInfo = (await storage.read(key: "login"));
    setState((){
      UserId = UserInfo!.split('@')[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset(
          'appbar.png',
          height: 45,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.only(right: 13),
                child: Text(
                  '${UserId} 님',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const Divider(
            color: Colors.black,
            thickness: 0.8,
            height: 5,
            indent: 10,
            endIndent: 10,
          ),
          SizedBox(
            height: 50,
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
          const Divider(
            color: Colors.black,
            thickness: 0.8,
            height: 5,
            indent: 10,
            endIndent: 10,
          ),
          SizedBox(
            height: 50,
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
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 0.8,
            height: 5,
            indent: 10,
            endIndent: 10,
          ),
          SizedBox(
            height: 50,
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
          const Divider(
            color: Colors.black,
            thickness: 0.8,
            height: 5,
            indent: 10,
            endIndent: 10,
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '   체질 설정',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 9,
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
                        children: const [
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '추워요',
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(
                            width: 45,
                          ),
                          Text(
                            '보통',
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(
                            width: 45,
                          ),
                          Text(
                            '더워요',
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 0.8,
            height: 5,
            indent: 10,
            endIndent: 10,
          ),
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/closet');
            },
            child: Container(
              color: Colors.white,
              height: 50,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '   내 옷장',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 0.8,
            height: 5,
            indent: 10,
            endIndent: 10,
          ),
          GestureDetector(
            onTap: (){
              context.read<Users>().readDB();
              FirebaseAuth.instance.signOut();
              storage.delete(key: 'login');
              Navigator.popUntil(context,(route)=>route.isFirst);
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
            child: Container(
              color: Colors.white,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '   로그아웃',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 0.8,
            height: 5,
            indent: 10,
            endIndent: 10,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
            if (index == 0) {
              Navigator.pushNamed(context, '/main',);
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