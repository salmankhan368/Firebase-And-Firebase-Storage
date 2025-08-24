import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:project_firebase/auth/verify_screen.dart';
import 'package:project_firebase/utils/Utils.dart';
import 'package:project_firebase/widgets/Round_button.dart';
import 'package:project_firebase/widgets/app_color.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final LoginWithPhoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColor.tealColor,
          title: Text(
            "login with phone",
            style: TextStyle(color: AppColor.whiteColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 25),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: LoginWithPhoneNumberController,
                decoration: InputDecoration(
                  hintText: '+92',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 50),
              RoundButton(
                title: 'login with phone',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  auth.verifyPhoneNumber(
                    phoneNumber: LoginWithPhoneNumberController.text,
                    verificationCompleted: (_) {
                      setState(() {
                        loading = false;
                      });
                    },
                    verificationFailed: (e) {
                      Utils().toastMessage(e.toString());
                    },
                    codeSent: (String verificationId, int? token) {
                      setState(() {
                        loading = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VerifyScreen(verificationId: verificationId),
                        ),
                      );
                    },
                    codeAutoRetrievalTimeout: (e) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(e.toString());
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
