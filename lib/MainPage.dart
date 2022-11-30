import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'Weather_Location.dart';
import 'dart:convert';


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

  @override
  void initState() {
    super.initState();

  }

  Future<void> getWeeklyWeather(double? lat, double? lon) async {

    final _openweatherkey = FlutterConfig.get('apiKey');
    var str =
        Uri.parse(
            'http://api.openweathermap.org/data/2.5/forecast/?lat=$lat&lon=$lon&appid=$_openweatherkey&units=metric');

    var response = await http.get(str);
    if (response.statusCode == 200) {

      //var dataJson = jsonDecode(data); // string to json
      var data = response.body;

      var dataJson = jsonDecode(data);




      var description = dataJson['list'][0]['weather'][0]['description'];

    } else {
      print('response status code = ${response.statusCode}');
    }


  }

  String getWeatherText(double? temp, double? feels_like){
    var text='좋은 하루 되세요!';
    if(temp!-feels_like!>=5.0&&temp<=5.0){
      text = '날씨가 많이 춥네요. 옷은 따뜻하게 입으시고 \n'+
          '감기 조심하세요!';
    }
    return text;
  }

  Widget build(BuildContext context) {
    final pm10 = context.watch<Weather_Location>().pm10_status;
    final pm2_5 = context.watch<Weather_Location>().pm2_5_status;
    final temp = context.watch<Weather_Location>().temp;
    final feels_like = context.watch<Weather_Location>().feels_like;
    final pop = context.watch<Weather_Location>().pop;
    final description = context.watch<Weather_Location>().description;
    final city = context.watch<Weather_Location>().city_name;
    final lat = context.watch<Weather_Location>().lat;
    final lon = context.watch<Weather_Location>().lon;

    String locationDropdownValue = city!;
    String image = '10d@2x.png';
    String weather_status = '맑음';




    getWeeklyWeather(lat,lon);



    switch(description){
      case 'clear sky':
        image = '01d@2x.png';
        weather_status = '맑음';
        break;
      case 'few clouds':
        image = '02d@2x.png';
        weather_status = '구름 조금';
        break;
      case 'scattered clouds':
        image = '03d@2x.png';
        weather_status = '적란운';
        break;
      case 'broken clouds':
        image = '04d@2x.png';
        weather_status = '구름 많음';
        break;
      case 'shower rain':
        image = '09d@2x.png';
        weather_status = '소나기';
        break;
      case 'rain':
        image = '10d@2x.png';
        weather_status = '비';
        break;
      case 'thunderstorm':
        image = '11d@2x.png';
        weather_status = '천둥번개를 동반한 비';
        break;
      case 'snow':
        image = '13d@2x.png';
        weather_status = '눈';
        break;
      case 'mist':
        image = '50d@2x.png';
        weather_status = '안개';
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
                          items: <String>[city!,'동네추가'].map<DropdownMenuItem<String>>((String value) {
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
                       '강수확률 ${pop!*100}%',
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
                        '${temp!.toStringAsFixed(1)}℃',
                        style: TextStyle(fontSize: 40,),
                      ),
                      Text(
                        '체감온도 ${feels_like!.toStringAsFixed(1)} ℃',
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


class WeatherListElement extends StatelessWidget {
  const WeatherListElement({Key? key, this.dayOfWeek, this.weather,this.min_temp,this.max_temp})
      : super(key: key);
  final String? dayOfWeek;
  final String? weather;
  final double? min_temp;
  final double? max_temp;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
         Text(
          '$dayOfWeek!',
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
        ),
      ],
    );
  }

}