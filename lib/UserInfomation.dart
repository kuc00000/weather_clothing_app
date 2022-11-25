import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Users with ChangeNotifier{
  final _authentication = FirebaseAuth.instance;


}

// class UserInfo {
//   int sex;
//   String email;
//
// }