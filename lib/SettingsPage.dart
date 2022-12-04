import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TimeSetting.dart';
import 'UserInfomation.dart';
import 'FeedbackPage.dart';

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
  RangeValues _currentRangeValues = RangeValues(0, 20);
  int currentPageIndex = 2;
  static final storage = FlutterSecureStorage();
  final _authentication = FirebaseAuth.instance;
  String? UserInfo='';
  String? UserId='';
  var prefs;
  @override
  void initState(){
    super.initState();
    intValue();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _asyncMethod();
    });
  }
  void intValue() async{
    prefs = await SharedPreferences.getInstance();
  }
  _asyncMethod() async {
    final myInfo = await FirebaseFirestore.instance.collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid).get();
    UserInfo = (await storage.read(key: "login"));
    setState((){
      UserId = UserInfo!.split('@')[0];
      _currentRangeValues = RangeValues(myInfo.data()!['userConstitution'][0].toDouble(), myInfo.data()!['userConstitution'][1].toDouble());
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
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  '${UserId} 님',
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
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
              showDialog(context: context, builder: (BuildContext context){
                return feedbackPage();
              });
            },
            child: Container(
              color: Colors.white,
              height: 55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '   오늘의 피드백',
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
              Navigator.pushNamed(context, '/closet');
            },
            child: Container(
              color: Colors.white,
              height: 55,
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
          SizedBox(
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '   내 체질 정보',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
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
                        child: Container(
                          width: MediaQuery.of(context).size.width/2,
                          child: RangeSlider(
                            values: _currentRangeValues,
                            min: 0,
                            max: 40,
                            divisions: 40,
                            labels: RangeLabels(
                              _currentRangeValues.start.round().toString(),
                              _currentRangeValues.end.round().toString(),
                            ),
                            onChanged: (RangeValues values) {
                              setState(() {
                                //  _currentRangeValues = values;
                              });
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '추워요',
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width/5-10,
                          ),
                          Text(
                            '보통',
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width/5-10,
                          ),
                          Text(
                            '더워요',
                            style: TextStyle(
                              fontSize: 11,
                            ),
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
              showDialog(context: context,
                  builder: (context) => SimpleDialog(
                    title: const Center(child: Text('안내문')),
                    contentPadding: const EdgeInsets.all(10),
                    children: [
                      Center(child: Text('로그아웃 하시겠습니까?')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: (){
                                context.read<Users>().readDB();
                                FirebaseAuth.instance.signOut();
                                storage.delete(key: 'login');
                                prefs.remove('user');

                                Navigator.popUntil(context,(route)=>route.isFirst);
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/login');
                              },
                              child: const Text('확인')),
                          TextButton(
                              onPressed: (){ Navigator.pop(context);},
                              child: const Text('취소')),
                        ],
                      ),

                    ],
                  )
              );
            },
            child: Container(
              color: Colors.white,
              height: 55,
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
              Navigator.pop(context);
              Navigator.pushNamed(context, '/main',);
            } else if (index == 1) {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/calendar');
            } else {
              Navigator.pop(context);
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