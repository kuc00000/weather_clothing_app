import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  final theme = ThemeData.light();

  @override

  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

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
                  switch(day.weekday){
                    case 1:
                      return Center(child: Text('월'),);
                    case 2:
                      return Center(child: Text('화'),);
                    case 3:
                      return Center(child: Text('수'),);
                    case 4:
                      return Center(child: Text('목'),);
                    case 5:
                      return Center(child: Text('금'),);
                    case 6:
                      return Center(child: Text('토',style: TextStyle(color: Colors.blue),),);
                    case 7:
                      return Center(child: Text('일',style: TextStyle(color: Colors.red),),);
                  }
                },
              ),
              firstDay: DateTime.utc(2022, 11, 1),
              lastDay: DateTime.utc(2023, 12, 31),
              focusedDay: DateTime.now(),
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
                if (day.day%4==0) {
                  return ['feedback'];
                }
                return [];
              },
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 3,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 2,
                    ),
                    Transform.scale(
                      scale: 0.70,
                      child: CupertinoSwitch(
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
                  '비슷한 날씨일 때의 옷차림과 피드백만 보기     ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          WeekClothList(),
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

class WeekClothList extends StatefulWidget {

  @override
  State<WeekClothList> createState() => _WeekClothListState();
}

class _WeekClothListState extends State<WeekClothList> {

  final List<String> clothingOuter = <String>['환절기 코트', '가죽자켓', '가죽자켓', '가죽자켓', '가죽자켓', '가죽자켓', '가죽자켓'];
  final List<String> clothingTop = <String>['반팔티셔츠', '반팔티셔츠', '반팔티셔츠', '반팔티셔츠', '반팔티셔츠', '상의 없음', '상의 없음'];
  final List<String> clothingBottom = <String>['코튼팬츠', '코튼팬츠', '코튼팬츠', '코튼팬츠', '코튼팬츠', '하의 없음', '하의 없음'];
  final List<String> clothingDress = <String>['원피스 없음', '원피스 없음', '원피스 없음', '원피스 없음', '원피스 없음', '봄가을용 원피스', '겨울용 원피스'];
  final List<String> feedbacks = <String>['약간 더웠음', '매우 더웠음', '약간 추웠음', '매우 추웠음', '보통', '약간 더웠음', '약간 더웠음'];
  final List<String> maxDayTemperature = <String>['24', '24', '25', '23', '20', '18', '16'];
  final List<String> minDayTemperature = <String>['14', '14', '15', '13', '10', '08', '06'];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 7,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text('${(7 - index).toString()}일 전',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: 110,
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text('${minDayTemperature[index]} ~ ${minDayTemperature[index]} ℃',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text('${feedbacks[index]}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 120,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('- ${clothingOuter[index]}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text('- ${clothingTop[index]}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text('- ${clothingBottom[index]}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text('- ${clothingDress[index]}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

