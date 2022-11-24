import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Map<String,String> cities = {'지역을 선택해주세요.':'기본','연천군':'Yeoncheon-gun','의정부시':'Uijeongbu-si','서울':'Seoul','인천':'Incheon',
  '안산시':'Ansan-si','수원시':'Suwon-si','이천시':'Icheon-si','오산':'Osan','안성':'Anseong','천안':'Cheonan',
  '춘천':'Chuncheon','화천':'Hwacheon','양구':'Yanggu','고성':'Kosong','속초':'Sokcho','인제':'Inje',
  '구리시':'Guri-si','하남':'Hanam','부천':'Bucheon-si','성남':'Seeongnam-si','양평':'Yangpyong',
  '여주':'Yeoju','광주':'Gwangju','제주시':'Jeju City', '부산': 'Busan','울산' : 'Ulsan',
  '전주':'Jeonju','임실':'Imsil','함양':'Hamyang','청주시':'Cheongju-si','공주시':'Gongju',
  '군산':'Gunsan', '창녕':'Changnyeong','동해':'Tonghae','마산':'Masan','안동':'Andong'};
List<String> cityList = ['지역을 선택해주세요.'];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  int pass = 0;
  final _openweatherkey = '3cdec813571d0497b65e5a20577293b7';

  String dropdownValue = cityList.first;
  double? temp;
  double? feels_like;
  int? pop;
  double? pm2_5; //초미세먼지 단위 μg/m3
  double? pm10; //미세먼지 단위 μg/m3
  String? pm10_status;
  String? pm2_5_status;
  @override
  void initState() {
    super.initState();
    getPosition();
  }

  Future<void> getPosition() async {
    setState((){
      cityList = cities.keys.toList();
    });

  }

  Future<void> getWeatherDataByName({
    required String city_kor
  }) async {


    var city = cities[city_kor];
    var lat;
    var lon;



    /*var str =
    Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_openweatherkey&lang=kor&units=metric');
    print(str);*/


    //해당 지역 이름에 해당하는 위도 경도를 가져오는 코드
    var str =
    Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$city_kor&limit=1&appid=$_openweatherkey');
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
      temp = dataJson['list'][0]['main']['temp'];
      feels_like = dataJson['list'][0]['main']['feels_like'];
      pop = dataJson['list'][0]['pop'];
      print(pop);
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
                });

                getWeatherDataByName(
                    city_kor:value!);
              },
              items: cityList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const Text(
              '국내 동/면/읍을 입력해주세요 ex) 상도동',
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
              setState(() {
                Navigator.pushNamed(context, '/add',arguments:{'temp':temp,'feels_like':feels_like,'pm10':pm10_status,'pm2_5':pm2_5_status,'pop':pop});
              });
            }, child: const Text('Next')),
          ],
        ),
      ),
    );
  }
}