import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:project_firebase/Routes/routes_name.dart';
import 'package:project_firebase/utils/Utils.dart';

import 'package:project_firebase/widgets/Round_button.dart';
import 'package:project_firebase/widgets/app_color.dart';

class VerifyScreen extends StatefulWidget {
  final String verificationId;
  const VerifyScreen({super.key, required this.verificationId});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final VerifyScreenController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColor.tealColor,
          title: Text(
            "Verify screen",
            style: TextStyle(color: AppColor.whiteColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 25),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: VerifyScreenController,
                decoration: InputDecoration(
                  hintText: '6 digit code',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 50),
              RoundButton(
                title: 'verification',
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: VerifyScreenController.text.toString(),
                  );
                  try {
                    await auth.signInWithCredential(credential);
                    Navigator.pushNamed(context, RoutesName.post);
                  } catch (e) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(e.toString());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
