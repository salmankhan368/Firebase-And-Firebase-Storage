import 'package:flutter/material.dart';
import 'package:project_firebase/FireStore/firestore_data.dart';
import 'package:project_firebase/FireStore/firestore_screen.dart';
import 'package:project_firebase/Routes/routes_name.dart';
import 'package:project_firebase/Uis/Splash_Screen.dart';
import 'package:project_firebase/auth/SignUp_screen.dart';
import 'package:project_firebase/auth/login_screen.dart';
import 'package:project_firebase/auth/login_with_phone_number.dart';

import 'package:project_firebase/posts/Post_screen.dart';
import 'package:project_firebase/posts/add_post_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => SplashScreen(),
        );
      case RoutesName.login:
        return MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(),
        );
      case RoutesName.signUp:
        return MaterialPageRoute(
          builder: (BuildContext context) => SignUpscreen(),
        );
      case RoutesName.post:
        return MaterialPageRoute(
          builder: (BuildContext context) => PostScreen(),
        );
      case RoutesName.phone:
        return MaterialPageRoute(
          builder: (BuildContext context) => LoginWithPhoneNumber(),
        );
      case RoutesName.add:
        return MaterialPageRoute(
          builder: (BuildContext context) => AddPostScreen(),
        );
      case RoutesName.firestore:
        return MaterialPageRoute(
          builder: (BuildContext context) => FirestoreScreen(),
        );
      case RoutesName.fireData:
        return MaterialPageRoute(
          builder: (BuildContext context) => FireStoreData(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) {
            return Scaffold(body: Center(child: Text("No define routes")));
          },
        );
    }
  }
}
