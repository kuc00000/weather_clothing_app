import 'package:flutter/material.dart';

class Weather_Location {
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

  }
  setLon(double? lon){
    this.lon = lon;

  }
  setTemp(double? temp){
    this.temp = temp;

  }
  setFeels_like(double? feels_like){
    this.feels_like = feels_like;

  }
  setPm10(String? pm10_status){
    this.pm10_status = pm10_status;

  }
  setpm2_5(String? pm2_5_status){
    this.pm2_5_status = pm2_5_status;

  }
  setPop(double? pop){
    this.pop = pop;

  }

  setProvince(String? province){
    this.province = province;

  }
  setCity(String? city_name){
    this.city_name = city_name;

  }

  setDescription(String? description){
    this.description = description;
  }



}