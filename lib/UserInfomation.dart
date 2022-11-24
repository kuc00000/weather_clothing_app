import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Users with ChangeNotifier{
  final _authentication = FirebaseAuth.instance;
  trySignup(email,password) async {
    try{
      final newUser = await _authentication.createUserWithEmailAndPassword(
          email: email, password: password);
      return newUser.user;
    }catch(e){
      print(e);
    }
    notifyListeners();
  }
  tryLogin(email,password) async {
    try {
      final currentUser = await _authentication.signInWithEmailAndPassword(
          email: email, password: password);
      return currentUser.user;
    } catch(e){
      print(e);
    }
    notifyListeners();
  }
}

// class UserInfo {
//   int sex;
//   String email;
//
// }