import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Users with ChangeNotifier{
  int userSex=0;
  dynamic myOuter = List.generate(16, (i) => true);
  dynamic myTop = List.generate(10, (i) => false);
  dynamic myBottom = List.generate(9, (i) => false);

  readDB () async {
    final userInfo = await FirebaseFirestore.instance.collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid).get();
    userSex = userInfo.data()!['userSex'];
    myOuter = userInfo.data()!['outer'];
    myTop = userInfo.data()!['top'];
    myBottom = userInfo.data()!['bottom'];
    notifyListeners();
  }
  getOuter(){
    return myOuter;
    notifyListeners();
  }
  getTop(){
    return myTop;
    notifyListeners();
  }
  getBottom(){
    return myBottom;
    notifyListeners();
  }
  setUserSex(sex){
    userSex = sex;
    notifyListeners();
  }
  setCloset(part, closet){
    if(part == 'outer'){
      myOuter = closet;
    } else if (part == 'top'){
      myTop = closet;
    } else{
      myBottom = closet;
    }
    notifyListeners();
  }
  addCloset(part,index,value){
    if(part == 'outer'){
      myOuter[index] = value;
    } else if (part == 'top'){
      myTop[index] = value;
    } else{
      myBottom[index] = value;
    }
    notifyListeners();
  }
}

// class UserInfo {
//   int sex;
//   String email;
//
// }