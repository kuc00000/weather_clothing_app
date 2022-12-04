import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
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
  const MainPage({super.key, required this.title});

  final String title;

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

  final List<String> clothingOuter = <String>['환절기 코트', '가죽자켓', '가죽자켓', '가죽자켓', '가죽자켓'];
  final List<String> clothingTop = <String>['긴팔티셔츠', '반팔티셔츠', '긴팔티셔츠', '반팔티셔츠', '반팔티셔츠'];
  final List<String> clothingBottom = <String>['코튼팬츠', '코튼팬츠', '코튼팬츠', '코튼팬츠', '코튼팬츠'];




  List<Weather> weatherList = [];

  @override
  void initState() {
    initValue();
    super.initState();

    getWeeklyWeather();

  }


  Future<void> initValue() async{
    prefs = await SharedPreferences.getInstance();
    setState((){


      city =prefs.getString('city');
      temp = prefs.getDouble('temp');
      feels_like = prefs.getDouble('feels_like');
      pop = prefs.getDouble('pop');
      pm10 = prefs.getString('pm10');
      pm2_5 = prefs.getString('pm2_5');
      description = prefs.getString('description');
      lat = prefs.getDouble('lat');
      lon = prefs.getDouble('lon');
    });

  }
  Future<List<Weather>> getWeeklyWeather() async {
    final prefs = await SharedPreferences.getInstance();
    lat = prefs.getDouble('lat');
    lon = prefs.getDouble('lon');
    final _openweatherkey = FlutterConfig.get('apiKey');
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
      case 'clear sky':
        image = '01d@2x.png';

        break;
      case 'few clouds':
        image = '02d@2x.png';

        break;
      case 'scattered clouds':
        image = '03d@2x.png';

        break;
      case 'light rain':
        image ='10d@2x.png';
        break;
      case 'broken clouds':
        image = '04d@2x.png';

        break;
      case 'shower rain':
        image = '09d@2x.png';

        break;
      case 'light snow':
        image = '13d@2x.png';
        break;

      case 'rain':
        image = '10d@2x.png';

        break;
      case 'overcast clouds':
        image = '04d@2x.png';
        break;
      case 'thunderstorm':
        image = '11d@2x.png';

        break;
      case 'snow':
        image = '13d@2x.png';

        break;
      case 'mist':
        image = '50d@2x.png';

        break;

    }


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
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 200,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                      child: Container(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 380,
                              child: Card(
                                color: Color(0xffF2F2F2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('상의',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text('${clothingTop[index]}',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('하의',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text('${clothingBottom[index]}',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('아우터',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text('${clothingOuter[index]}',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 20,
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


            /*Row(
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
            ),*/
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
        selectedItemColor: Colors.lightBlue,
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