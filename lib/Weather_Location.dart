import 'package:flutter/material.dart';

class Weather_Location with ChangeNotifier{
  double? temp; //하루 평균온도
  double? feels_like; //체감온도
  String? pm10_status; //미세먼지 수치
  String? pm2_5_status; //초미세먼지 수치
  double? pop; //강수량
  double? wind_speed; //풍속

  String? province;
  String? city_name;
  String? description;

  double? lat;
  double? lon;

  setwindSpeed(double? wind_speed){
    this.wind_speed = wind_speed;
  }

  setLat(double? lat){
    this.lat = lat;
    notifyListeners();
  }
  setLon(double? lon){
    this.lon = lon;
    notifyListeners();
  }
  setTemp(double? temp){
    this.temp = temp;
    notifyListeners();
  }
  setFeels_like(double? feels_like){
    this.feels_like = feels_like;
    notifyListeners();
  }
  setPm10(String? pm10_status){
    this.pm10_status = pm10_status;
    notifyListeners();
  }
  setpm2_5(String? pm2_5_status){
    this.pm2_5_status = pm2_5_status;
    notifyListeners();
  }
  setPop(double? pop){
    this.pop = pop;
    notifyListeners();
  }

  setProvince(String? province){
    this.province = province;
    notifyListeners();
  }
  setCity(String? city_name){
    this.city_name = city_name;
    notifyListeners();
  }

  setDescription(String? description){
    this.description = description;
    notifyListeners();
  }



}