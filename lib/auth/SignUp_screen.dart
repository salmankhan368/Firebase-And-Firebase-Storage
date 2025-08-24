import 'package:flutter/material.dart';
import 'package:project_firebase/utils/Utils.dart';
import 'package:project_firebase/widgets/Round_button.dart';
import 'package:project_firebase/widgets/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpscreen extends StatefulWidget {
  const SignUpscreen({super.key});

  @override
  State<SignUpscreen> createState() => _SignUpscreenState();
}

class _SignUpscreenState extends State<SignUpscreen> {
  bool loading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  ValueNotifier<bool> _obsecurePassword = ValueNotifier<bool>(true);
  final _formkey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColor.tealColor,
          title: Center(
            child: Text(
              "Signup Screen",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.whiteColor,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        prefixIcon: Icon(Icons.mail),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      onFieldSubmitted: (value) {
                        Utils.fieldfocusChange(
                          context,
                          emailFocusNode,
                          passwordFocusNode,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "enter your email please";
                        } else {
                          return null;
                        }
                      },
                    ),

                    SizedBox(height: 15),
                    ValueListenableBuilder(
                      valueListenable: _obsecurePassword,
                      builder: (context, value, child) {
                        return TextFormField(
                          focusNode: passwordFocusNode,
                          controller: passwordController,
                          obscureText: _obsecurePassword.value,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: InkWell(
                              onTap: () {
                                _obsecurePassword.value =
                                    !_obsecurePassword.value;
                              },
                              child: Icon(
                                _obsecurePassword.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility,
                              ),
                            ),

                            filled: true,
                            prefixIcon: Icon(Icons.lock_open_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "enter your password please";
                            } else {
                              return null;
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 18),

              RoundButton(
                title: "SIgn Up",
                loading: loading,
                onTap: () {
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    _auth
                        .createUserWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password: passwordController.text.toString(),
                        )
                        .then((value) {
                          Utils().toastMessage("post uploded Scessfully");
                          setState(() {
                            loading = false;
                          });
                        })
                        .onError((error, stackTrace) {
                          Utils().toastMessage(error.toString());
                          setState(() {
                            loading = false;
                          });
                        });
                  }
                },
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Login",
                      style: TextStyle(color: AppColor.tealColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
