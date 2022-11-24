import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Users with ChangeNotifier{
  final _authentication = FirebaseAuth.instance;
  trySignup(email,password) async {

    var newUser = await _authentication.createUserWithEmailAndPassword(
        email: email, password: password);
    notifyListeners();

  }
}