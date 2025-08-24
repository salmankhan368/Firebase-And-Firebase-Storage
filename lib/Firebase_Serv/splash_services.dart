import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_firebase/Routes/routes_name.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(
        Duration(seconds: 3),
        () => Navigator.pushNamed(context, RoutesName.firestore),
      );
    } else {
      Timer(
        Duration(seconds: 3),
        () => Navigator.pushNamed(context, RoutesName.login),
      );
    }
  }
}
