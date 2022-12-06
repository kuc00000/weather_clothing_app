import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weather_app2/mainColor.dart';

import 'Weather_Location.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.title});

  final String title;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String pass = '';
  bool _calendarswitch = true;
  int currentPageIndex = 1;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? date;
  final theme = ThemeData.light();
  int lenDate = 0;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    final feedInfo = await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .get();
    // print(feedInfo.docs.map((e) => print(e.reference.id)));
    setState(() {
      date = feedInfo.docs.toList();
    });
    lenDate = date!.length;
    // date?.removeAt(date!.length);
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
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
        children: [
          SizedBox(
            height: 370,
            child: TableCalendar(
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  switch (day.weekday) {
                    case 1:
                      return Center(
                        child: Text('월'),
                      );
                    case 2:
                      return Center(
                        child: Text('화'),
                      );
                    case 3:
                      return Center(
                        child: Text('수'),
                      );
                    case 4:
                      return Center(
                        child: Text('목'),
                      );
                    case 5:
                      return Center(
                        child: Text('금'),
                      );
                    case 6:
                      return Center(
                        child: Text(
                          '토',
                          style: TextStyle(color: Colors.blue),
                        ),
                      );
                    case 7:
                      return Center(
                        child: Text(
                          '일',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                  }
                },
              ),
              firstDay: DateTime.utc(2022, 11, 1),
              lastDay: DateTime.utc(2023, 12, 31),
              focusedDay: DateTime.fromMicrosecondsSinceEpoch(DateTime.now().microsecondsSinceEpoch+32400000000),
              currentDay: DateTime.fromMicrosecondsSinceEpoch(DateTime.now().microsecondsSinceEpoch+32400000000),
              locale: 'ko-KR',
              daysOfWeekHeight: 30,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red,
                    width: 1.5,
                  ),
                ),
                todayTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              eventLoader: (day) {
                for (int i = 0; i < lenDate; i++) {
                  if ((int.parse(
                              date![i].reference.id.toString().split('-')[2]) ==
                          day.day) &&
                      (int.parse(
                              date![i].reference.id.toString().split('-')[1]) ==
                          day.month)) {
                    return ['feedback'];
                  }
                }
                return [];
              },
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 2,
                    ),
                    Transform.scale(
                      scale: 0.70,
                      child: CupertinoSwitch(
                        activeColor: AppColor.mainColor,
                        value: _calendarswitch,
                        onChanged: (bool value) {
                          setState(() {
                            _calendarswitch = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const Text(
                  '비슷한 날씨일 때의 옷차림과 피드백 보기',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          _calendarswitch ? WeekClothList() : Container(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
            if (index == 0) {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/main');
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
        selectedItemColor: AppColor.mainColor,
      ),
    );
  }
}

class WeekClothList extends StatefulWidget {
  @override
  State<WeekClothList> createState() => _WeekClothListState();
}



class _WeekClothListState extends State<WeekClothList> {
  List<String>? outers = [
    '바람막이',
    '청자켓',
    '야상',
    '트러커자켓',
    '가디건',
    '플리스',
    '야구잠바',
    '항공잠바',
    '가죽자켓',
    '환절기코트',
    '조끼패딩',
    '무스탕',
    '숏패딩',
    '겨울코트',
    '돕바',
    '롱패딩'
  ];
  List<String>? tops = [
    '민소매티',
    '반소매티',
    '긴소매티',
    '셔츠',
    '맨투맨',
    '후드티셔츠',
    '목폴라',
    '니트',
    '여름블라우스',
    '봄가을블라우스'
  ];
  List<String>? bottoms = [
    '숏팬츠',
    '트레이닝팬츠',
    '슬랙스',
    '데님팬츠',
    '코튼팬츠',
    '여름스커트',
    '봄가을스커트',
    '레깅스',
    '겨울스커트'
  ];
  final List<String>? feedbacks = <String>[
    '추웠어요',
    '조금추웠어요',
    '적당했어요',
    '조금더웠어요',
    '더웠어요'
  ];
  final List<String> maxDayTemperature = <String>[
    '24',
    '24',
    '25',
    '23',
    '20',
    '18',
    '16'
  ];
  final List<String> minDayTemperature = <String>[
    '14',
    '14',
    '15',
    '13',
    '10',
    '08',
    '06'
  ];
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? date;

  double? temp;

  final storage = FlutterSecureStorage();
  String? UserInfo;
  String? weatherPref;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    final feedInfo = await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .get();
    // print(feedInfo.docs.map((e) => print(e.reference.id)));
    setState(() {
      date = feedInfo.docs.toList();
    });

    // date?.removeAt(date!.length);
  }

  Future<double> initValue() async {
    UserInfo = (await storage.read(key: "login"));
    final prefs = await SharedPreferences.getInstance();
    weatherPref = prefs.getString(UserInfo!.split(' ')[0]);
    Map<String,dynamic> userMap = jsonDecode(weatherPref!) as Map<String, dynamic>;
    temp = userMap!['temp'];
    return temp!;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder(
            future: initValue(),
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              if (snapshot.hasData) {
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(FirebaseAuth.instance.currentUser!.uid)
                      .where('temperature',
                          isGreaterThan: temp!.round() - 30,
                          isLessThan: temp!.round() + 30)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final docs = snapshot.data?.docs;

                    return
                      date?.length!=0?
                      ListView.builder(
                      itemCount: docs?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                date?[index].reference.id.toString()!=null?Text('${date?[index].reference.id.toString()}'):Container(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    docs?[index]['temperature']!=null?
                                    Text('${docs?[index]['temperature']} °'):Container(),
                                    docs?[index]['feedback'] != null
                                        ? Text(
                                            '${feedbacks?[docs?[index]['feedback']]}')
                                        : Container(),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Stack(children: [
                                        docs?[index]['top'] != null
                                            ? Image.asset(
                                                'top${docs?[index]['top']}.png',
                                                height: 45,
                                              )
                                            : Container(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(' '),
                                            docs?[index]['top'] != null
                                                ? Text(
                                                    tops![docs?[index]['top']],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Container()
                                          ],
                                        )
                                      ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Stack(children: [
                                        docs?[index]['bottom'] != null
                                            ? Image.asset(
                                                'bottom${docs?[index]['bottom']}.png',
                                                height: 45,
                                              )
                                            : Container(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(' '),
                                            docs?[index]['bottom'] != null
                                                ? Text(
                                                    bottoms![docs?[index]
                                                        ['bottom']],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Container()
                                          ],
                                        )
                                      ]),
                                    ),
                                    docs?[index]['outer'] == -1
                                        ? Container()
                                        : Stack(children: [
                                            docs?[index]['outer'] != null
                                                ? Image.asset(
                                                    'outer${docs?[index]['outer']}.png',
                                                    height: 45,
                                                  )
                                                : Container(),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(' '),
                                                docs?[index]['outer'] != null
                                                    ? Text(
                                                        outers![docs?[index]
                                                            ['outer']],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Container()
                                              ],
                                            )
                                          ]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                            // Text('${docs?[index]['top']}'),
                            );
                      },
                    ):Container();
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}
