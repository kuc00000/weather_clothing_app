import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

List<String> province = ['도를 선택해주세요.','경기도','충청도','전라도','강원도','경상도','제주도'];


List<String> cityList = ['지역을 선택해주세요.'];


Map<String,String> Gyeonggi = {'지역을 선택해주세요.':'기본','연천군':'Yeoncheon-gun','의정부시':'Uijeongbu-si','서울':'Seoul','인천':'Incheon',
  '안산시':'Ansan-si','수원시':'Suwon-si','이천시':'Icheon-si','오산':'Osan','안성':'Anseong',
  '구리시':'Guri-si','하남':'Hanam','부천':'Bucheon-si','성남':'Seongnam-si','양평':'Yangpyong',
  '여주':'Yeoju','광주':'Gwangju','용인' : 'Yongin', '가평군' : 'Gapyeong County'};


Map<String,String> Chungcheong = {'지역을 선택해주세요.':'기본','옥천' : 'Okcheon',
  '청주시':'Cheongju-si','괴산': 'Koesan','공주시':'Gongju','보령' : 'Boryeong',
  '부여':'Buyeo','논산' : 'Nonsan'};

Map<String,String> Gangwon = {'지역을 선택해주세요.':'기본', '춘천':'Chuncheon','화천':'Hwacheon','양구':'Yanggu','고성':'Kosong','속초':'Sokcho','인제':'Inje',
  '동해':'Tonghae','강릉':'Gangneung'};

Map<String,String> Jeolla = {'지역을 선택해주세요.':'기본',
  '광주':'Gwangju','나주':'Naju','무안':'Muan','전주':'Jeonju','임실':'Imsil','신안군':'Sinan',
  '군산':'Gunsan', '마산':'Masan','안동':'Andong','진안군':'Jinan-gun','해남군':'Haenam','목포':'Mokpo','보성':'Boseong',
  '순천':'Suncheon'};


Map<String,String> Gyeongsang = {'지역을 선택해주세요.':'기본','부산': 'Busan','울산' : 'Ulsan',
  '창녕':'Changnyeong','신현':'Sinhyeon','마산':'Masan','함양':'Hamyang','안동':'Andong','포항':'Pohang', '경주': 'Gyeongju','경산시':'Gyeongsan-si','밀양':'Miryang','진주':'Jinju'};

Map<String,String> Jeju = {'지역을 선택해주세요.':'기본','제주시': 'Jeju City'};


