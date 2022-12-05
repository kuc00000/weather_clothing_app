import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app2/MainPage.dart';
import 'LocationAPI.dart';
import 'Weather_Location.dart';


class RevisePositionPage extends StatefulWidget {
  const RevisePositionPage({super.key});


  @override
  State<RevisePositionPage> createState() => _RevisedPositionPageState();
}



class _RevisedPositionPageState extends State<RevisePositionPage> {
  int pass = 0;
  final _openweatherkey = 'b2ece712030d8ca1ac751827e5e61afe';//FlutterConfig.get('apiKey');//'3cdec813571d0497b65e5a20577293b7';
  var prefs;
  String dropdownValue = province.first;
  String dropdownValue2 = cityList.first;
  double? temp;
  double? feels_like;
  double? pop;
  double? pm2_5; //초미세먼지 단위 μg/m3
  double? pm10; //미세먼지 단위 μg/m3
  String? pm10_status;
  String? pm2_5_status;
  String? description;
  double? lat;
  double? lon;

  String? UserInfo = '';

  static final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
  }


  void getInstance () async {
    prefs= await SharedPreferences.getInstance();

    UserInfo = (await storage.read(key: "login"));
  }
  void getPosition(String province) {
    setState(() {
      switch(province){

        case '경기도':
          cityList = Gyeonggi.keys.toList();
          break;
        case '충청도':
          cityList = Chungcheong.keys.toList();
          break;
        case '강원도':
          cityList = Gangwon.keys.toList();
          break;
        case '전라도':
          cityList = Jeolla.keys.toList();
          break;
        case '경상도':
          cityList = Gyeongsang.keys.toList();
          break;
        case '제주도':
          cityList = Jeju.keys.toList();
          break;

      }
    });


  }

  Future<void> getWeatherDataByName({
    required String province,
    required String city_name
  }) async {
    getInstance();

    context.loaderOverlay.show();
    var city;
    switch(province){

      case '경기도':
        city = Gyeonggi[city_name];
        break;
      case '충청도':
        city = Chungcheong[city_name];
        break;
      case '강원도':
        city = Gangwon[city_name];
        break;
      case '전라도':
        city = Jeolla[city_name];
        break;
      case' 경상도':
        city = Gyeongsang[city_name];
        break;
      case '제주도':
        city = Jeju[city_name];
        break;

    }



    /*var str =
    Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_openweatherkey&lang=kor&units=metric');
    print(str);*/
    print(city);

    //해당 지역 이름에 해당하는 위도 경도를 가져오는 코드
    var str =
    Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=1&appid=$_openweatherkey');
    var response = await http.get(str);

    if (response.statusCode == 200) {
      var data = response.body;
      var dataJson = jsonDecode(data); // string to json
      lat = dataJson[0]['lat'];
      lon = dataJson[0]['lon'];
    } else {
      print('response status code = ${response.statusCode}');
    }

    //날씨 정보 가져오는 코드
    str =
        Uri.parse(
            'http://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$_openweatherkey&units=metric&cnt=1');

    response = await http.get(str);
    if (response.statusCode == 200) {

      //var dataJson = jsonDecode(data); // string to json
      var data = response.body;

      var dataJson = jsonDecode(data);
      print(data);
      print(dataJson['list'][0]['main']['temp']);
      temp = dataJson['list'][0]['main']['temp'];
      feels_like = dataJson['list'][0]['main']['feels_like'];
      if(dataJson['list'][0]['pop']==0){
        pop = 0.0;
      }else{
        pop = dataJson['list'][0]['pop'];
      }

      description = dataJson['list'][0]['weather'][0]['description'];
      print(description);
    } else {
      print('response status code = ${response.statusCode}');
    }


    //미세먼지 정보 가져오는 코드
    str =
        Uri.parse(
            'http://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$_openweatherkey');

    response = await http.get(str);
    if (response.statusCode == 200) {
      var data = response.body;
      var dataJson = jsonDecode(data); // string to json
      print(data);

      pm10 = dataJson['list'][0]['components']['pm10'];


      if(pm10!>0 && pm10 !< 30){
        pm10_status = '좋음';
      }else if(pm10!>=30 && pm10 !< 80){
        pm10_status = '보통';
      }else if(pm10!>=80 && pm10 !< 150){
        pm10_status = '나쁨';
      }else if(pm10!>=150){
        pm10_status = '매우나쁨';
      }
      print('미세먼지 수치는? $pm10_status');

      pm2_5 = dataJson['list'][0]['components']['pm2_5'];

      if(pm2_5!>0 && pm2_5 !< 15){
        pm2_5_status = '좋음';
      }else if(pm2_5!>=15 && pm2_5 !< 35){
        pm2_5_status = '보통';
      }else if(pm2_5!>=35 && pm2_5 !< 75){
        pm2_5_status = '나쁨';
      }else if(pm2_5!>=75){
        pm2_5_status = '매우나쁨';
      }

    } else {
      print('response status code = ${response.statusCode}');
    }
    context.loaderOverlay.hide();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Image.asset(
          'appbar.png',
          height: 45,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '우리 동네를 검색해 찾아보세요',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;

                  cityList = ['지역을 선택해주세요.'];
                  dropdownValue2= cityList.first;
                });

                getPosition(value!);
              },
              items: province.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),

            DropdownButton<String>(
              value: dropdownValue2,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue2 = value!;
                });

                getWeatherDataByName(province:dropdownValue!,
                    city_name:value!);

              },
              items: cityList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const Text(
              '국내 도/시를 선택해주세요 ex) 경기도 광주시',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const Text(
              '동네의 날씨와 추천 옷차림을 볼 수 있어요',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () {

             Map<String,dynamic> weather = {
               'province':dropdownValue,
               'city':dropdownValue2,
               'temp':temp,
               'feels_like':feels_like,
               'pm10':pm10_status,
               'pm2_5' : pm2_5_status,
               'description' : description,
               'pop':pop,
               'lat':lat,
               'lon' : lon,
             };
             print("asdfasdfasfd");
             print(lat);
             print(lon);
             prefs.setString(UserInfo!.split(' ')[0],jsonEncode(weather));


              /*prefs.setString('province', dropdownValue);
              prefs.setString('city', dropdownValue2);
              prefs.setDouble('temp', temp);
              prefs.setDouble('feels_like', feels_like);
              prefs.setString('pm10', pm10_status);
              prefs.setString('pm10', pm10_status);
              prefs.setString('pm2_5', pm2_5_status);
              prefs.setString('description', description);
              prefs.setDouble('pop', pop);
              prefs.setDouble('lat', lat);
              prefs.setDouble('lon', lon);*/

              Navigator.pushNamed(context, '/main');
            }, child: const Text('Next')),
          ],
        ),
      ),
    );
  }
}