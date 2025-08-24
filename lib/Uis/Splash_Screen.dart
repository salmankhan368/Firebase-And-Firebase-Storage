import 'package:flutter/material.dart';
import 'package:project_firebase/Firebase_Serv/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(
          child: Container(
            // width: MediaQuery.of(context).size.width / 2,
            height: double.infinity,

            // width: double.infinity,
            child: Image.asset("Images/1.jpg"),
          ),
        ),
      ],
    );
    // Center(child: Text("My firebase project")),
  }
}
