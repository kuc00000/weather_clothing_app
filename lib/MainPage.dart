import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app2/mainColor.dart';
import 'OutfitRecommender.dart';
import 'UserInfomation.dart';
import 'Weather_Location.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as date;

class Weather{
  String? dayOfWeek;
  String? description;
  double? min_temp;
  double? max_temp;
  String? image;

  Weather(this.dayOfWeek,this.description, this.min_temp, this.max_temp,this.image);

  setDayOfWeek(String? dayOfWeek){
    this.dayOfWeek = dayOfWeek;
  }

  setDescription(String? description){
    this.description = description;
  }

  setMin_temp(double? min_temp){
    this.min_temp = min_temp;
  }

  setMax_temp(double? max_temp){
    this.max_temp = max_temp;
  }
}


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}



class _MainPageState extends State<MainPage> {


  String pass = '';

  int currentPageIndex = 0;
  double? lat;
  double? lon;
  var prefs;
  bool? loaded = false;

  String? pm10;
  String? pm2_5;
  double? temp;
  double? feels_like;
  double? pop ;
  String? description;
  String? city;


  Map<String,dynamic>? userMap;
  String? weatherPref;
  String? UserInfo;
  static final storage = FlutterSecureStorage();

  List<Weather> weatherList = [];
  List<List <int>> recommendList = [[-1,-1,-1],[1,3,4],[3,5,6],[2,5,2],[-1,0,0]];

  @override
  void initState() {
    initValue();
    super.initState();


    _asyncMethod();
  }
  _asyncMethod() async {
    final myInfo = await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if(!mounted)return;
    context.read<Users>().readDB();
    setState((){
      recommendList = outfitRecommendation([myInfo.data()!['userConstitution'][0],myInfo.data()!['userConstitution'][1]], temp!.toInt(),
          context.read<Users>().getOuter(),
          context.read<Users>().getTop(),
          context.read<Users>().getBottom());
    });


  }


  Future<void> initValue() async{
    UserInfo = (await storage.read(key: "login"));

    prefs = await SharedPreferences.getInstance();
    weatherPref = prefs.getString(UserInfo!.split(' ')[0]);
    userMap = jsonDecode(weatherPref!) as Map<String, dynamic>;

    setState((){

      city =userMap!['city'];
      temp = userMap!['temp'];
      feels_like = userMap!['feels_like'];
      pop = userMap!['pop'];
      pm10 = userMap!['pm10'];
      pm2_5 = userMap!['pm2_5'];
      description = userMap!['description'];
      lat = userMap!['lat'];
      lon = userMap!['lon'];
    });

    getWeeklyWeather();

  }
  Future<List<Weather>> getWeeklyWeather() async {

    final _openweatherkey = FlutterConfig.get('apiKey');

    print('위도 경도는?');
    print(lat);
    print(lon);
    var str =
    Uri.parse(
        'http://api.openweathermap.org/data/2.5/forecast/?lat=$lat&lon=$lon&appid=$_openweatherkey&units=metric');

    var response = await http.get(str);

      if (response.statusCode == 200) {

        //var dataJson = jsonDecode(data); // string to json
        var data = response.body;

        var dataJson = jsonDecode(data);

        print(dataJson['list'][8]);
        print(dataJson['list'].length);
        for(int i = 0; i<5;i++){
          int? daysOfWeek;
          var daysOfWeek_str = '';
          var date = DateTime.parse(dataJson['list'][i*8]['dt_txt']);
          var min_temp = dataJson['list'][i*8]['main']['temp_min'];
          var max_temp = dataJson['list'][i*8]['main']['temp_max'];
          print(date);
          daysOfWeek = date.weekday;

          switch(daysOfWeek){

            case 1:
              daysOfWeek_str='월';
              break;
            case 2:
              daysOfWeek_str='화';
              break;
            case 3:
              daysOfWeek_str='수';
              break;
            case 4:
              daysOfWeek_str='목';
              break;
            case 5:
              daysOfWeek_str='금';
              break;
            case 6:
              daysOfWeek_str='토';
              break;
            case 7:
              daysOfWeek_str='일';
              break;
          }

          var description = dataJson['list'][i*8]['weather'][0]['description'];
          print(description);
          var image = dataJson['list'][i*8]['weather'][0]['icon']+'@2x.png';
          setState(() {
            weatherList.add(Weather(daysOfWeek_str,description,min_temp,max_temp,image));

          });

        }

      } else {
        print('response status code = ${response.statusCode}');
      }

    return weatherList;

  }

  String getWeatherText(double? temp, double? feels_like){
    var text='좋은 하루 되시길 바랍니다!';
    temp = temp??0;
    feels_like = feels_like??0;
    if(temp!-feels_like!>=5.0&&temp<=5.0){
      text = '날씨가 많이 춥네요. 옷은 따뜻하게 입으시고 \n'+
          '감기 조심하세요';
    }
    return text;
  }

  Widget build(BuildContext context) {


    String locationDropdownValue = city??'서울';
    String image = '10d@2x.png';
    String weather_status = '맑음';



    switch(description){
      case 'clear sky': image = '01d@2x.png';
        break;
      case 'few clouds': image = '02d@2x.png';
        break;
      case 'scattered clouds': image = '03d@2x.png';
        break;
      case 'light rain': image ='10d@2x.png';
        break;
      case 'broken clouds':image = '04d@2x.png';
        break;
      case 'shower rain':image = '09d@2x.png';
        break;
      case 'light snow':image = '13d@2x.png';
        break;
      case 'rain':image = '10d@2x.png';
        break;
      case 'overcast clouds':image = '04d@2x.png';
        break;
      case 'thunderstorm':image = '11d@2x.png';
        break;
      case 'snow':image = '13d@2x.png';
        break;
      case 'mist':image = '50d@2x.png';
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'appbar.png',
          height: 45,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
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
                          items: <String>[city??'서울','동네추가'].map<DropdownMenuItem<String>>((String value) {
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
                      child: Center(child: Icon(Icons.umbrella_outlined,
                      color:Colors.black)),
                      decoration: BoxDecoration(
                        color: const Color(0xffCFE7EE),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                     Text(
                       '강수확률 ${pop??0*100}%',
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
                      child: Icon(Icons.masks,
                      color:Colors.white),
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
                  Image.network('http://openweathermap.org/img/wn/$image'),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${temp??0.toStringAsFixed(1)}℃',
                        style: TextStyle(fontSize: 40,),
                      ),
                      Text(
                        '체감온도 ${feels_like??0.toStringAsFixed(1)} ℃',
                        style: TextStyle(fontSize: 14,),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${getWeatherText(temp, feels_like)}',
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
            SizedBox(
              height: 200,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 7.0),
                      child:
                      recommendList.length!=0?
                      Container(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: recommendList.length,
                          itemBuilder: (context, index) {
                            return recommendTile(recommendList: recommendList[index]);
                          },
                        ),
                      )
                          :EmptyCard(),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 0.8,
              height: 5,
              indent: 10,
              endIndent: 10,
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
                IconButton(onPressed: () {
                  setState(()  {
                    weatherList = weatherList;
                  });



                }, icon: const Icon(Icons.refresh))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
                    shrinkWrap: true,
                    itemCount: weatherList.length,
                    itemBuilder: (context, index){
                      return  Column(
                          children : [
                            WeatherListElement(
                              dayOfWeek: weatherList[index].dayOfWeek,
                              weather: weatherList[index].description,
                              min_temp: weatherList[index].min_temp,
                              max_temp: weatherList[index].max_temp,
                              image: weatherList[index].image,
                            )
                          ],
                        );
                    },
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


class WeatherListElement extends StatelessWidget {
   WeatherListElement({Key? key, this.dayOfWeek, this.weather,this.min_temp,this.max_temp,this.image})
      : super(key: key);
  final String? dayOfWeek;
  final String? weather;
  final double? min_temp;
  final double? max_temp;
  final String? image;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
         Text(
          '$dayOfWeek',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Image.network('http://openweathermap.org/img/wn/$image'),
             Text(
              '${min_temp!}~${max_temp!}℃',
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
    );
  }

}

class recommendTile extends StatefulWidget {
  recommendTile({Key? key, required this.recommendList}) : super(key: key);

  List<int> recommendList = [1,3,4];

  @override
  State<recommendTile> createState() => _recommendTileState();
}

class _recommendTileState extends State<recommendTile> {

  List<String> outers=['바람막이', '청자켓','야상','트러커자켓','가디건',
    '플리스','야구잠바','항공잠바','가죽자켓','환절기코트','조끼패딩',
    '무스탕','숏패딩','겨울코트','돕바','롱패딩'];
  List<String> tops=['민소매티','반소매티','긴소매티','셔츠','맨투맨','후드티셔츠','목폴라','니트'
    ,'여름블라우스','봄가을블라우스'];
  List<String> bottoms=['숏팬츠','트레이닝팬츠','슬랙스','데님팬츠','코튼팬츠'
    ,'여름스커트','봄가을스커트','레깅스','겨울스커트'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [Container(
          width: 380,
          height: 250,
          child:Center(
            child: Container(
              width: 360,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                color: Color(0xffdec0ae),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: Offset(-8,-8),
                    color: Colors.white
                  ),
                  BoxShadow(
                    blurRadius: 10,
                    offset: Offset(8,8),
                    color: Color(0xFFA7A9AF)
                  )
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child:
                ((widget.recommendList[0]!=-1||widget.recommendList[1]!=-1||widget.recommendList[2]!=-1)
                &&(widget.recommendList.length!=0))?
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 16,left: 5),
                                child:Container(
                                  height: 100,
                                  width: 95,
                                  // color: Colors.white,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(
                                      blurRadius: 1,
                                      offset: Offset(0,0),
                                      color: Colors.white
                                    )]
                                  ),
                                  child: Image.asset(
                                         'top${widget.recommendList[1]}.png',
                                         width: 90,
                                      ),
                                )
                                // CircleAvatar(
                                //   radius: 50,
                                //   backgroundColor: Colors.white,
                                //   child: Image.asset(
                                //     'top${widget.recommendList[1]}.png',
                                //     width: 90,
                                //   ),
                                // ),
                              )
                            ],
                          ),
                          Container(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text('${tops[widget.recommendList[1]]}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 16,left: 2.5),
                                child: Container(
                                  height: 100,
                                  width: 95,
                                  // color: Colors.white,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [BoxShadow(
                                          blurRadius: 1,
                                          offset: Offset(0,0),
                                          color: Colors.white
                                      )]
                                  ),
                                  child: Image.asset(
                                    'bottom${widget.recommendList[2]}.png',
                                    width: 90,
                                  ),
                                )
                              )
                            ],
                          ),
                          Container(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${bottoms[widget.recommendList[2]]}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      widget.recommendList[0]!=-1?
                      Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Container(
                                  height: 100,
                                  width: 95,
                                  // color: Colors.white,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [BoxShadow(
                                          blurRadius: 1,
                                          offset: Offset(0,0),
                                          color: Colors.white
                                      )]
                                  ),
                                  child: Image.asset(
                                    'outer${widget.recommendList[0]}.png',
                                    width: 90,
                                  ),
                                )
                              )
                            ],
                          ),
                          Container(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 2),
                                  child: Text('${outers[widget.recommendList[0]]}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ):Container(width: 100,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 3,top: 2),
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.white,
                                  ),
                              ),

                            ],
                          ),
                    ],
                  ):Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Center(child: Text('가지고 계신 옷중에서 \n오늘 날씨에 적합한 옷을 찾지 못했습니다.',
                      textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
                  ),
                ),
              ),
            ),
          ),
        ),
          Container(
            width: 380,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(''),
                Image.asset(
                  'label.png',
                  height: 100,
                ),
              ],
            ),
          )
        ]
      ),
    );
  }
}
class EmptyCard extends StatefulWidget {
  const EmptyCard({Key? key}) : super(key: key);

  @override
  State<EmptyCard> createState() => _EmptyCardState();
}

class _EmptyCardState extends State<EmptyCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Stack(
          children: [

            Container(
            width: 380,
            height: 190,
            child:Center(
              child: Container(
                width: 360,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: Color(0xffdec0ae),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          offset: Offset(-8,-8),
                          color: Colors.white
                      ),
                      BoxShadow(
                          blurRadius: 10,
                          offset: Offset(8,8),
                          color: Color(0xFFA7A9AF)
                      )
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child:Container(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 45),
                            child: Center(child: Text('가지고 계신 옷중에서 \n오늘 날씨에 적합한 옷을 찾지 못했습니다.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15,top: 2),
                                child: CircleAvatar(
                                  radius: 7,
                                  backgroundColor: Colors.white,
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                  )
              ),
            ),
            Container(
              width: 380,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(''),
                  Image.asset(
                    'label.png',
                    height: 100,
                  ),
                ],
              ),
            )
          ]
      ),
    );
  }
}

