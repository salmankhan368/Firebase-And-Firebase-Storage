import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_firebase/Routes/routes_name.dart';
import 'package:project_firebase/utils/Utils.dart';
import 'package:project_firebase/widgets/Round_button.dart';
import 'package:project_firebase/widgets/app_color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  ValueNotifier<bool> _obsecurePassword = ValueNotifier<bool>(true);
  final _formkey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString(),
        )
        .then((value) {
          Utils().toastMessage("login suucefuly");
          Navigator.pushNamed(context, RoutesName.post);
          setState(() {
            loading = false;
          });
        })
        .onError((error, stackTrace) {
          setState(() {
            loading = false;
          });
          Utils().toastMessage(error.toString());
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColor.tealColor,
            title: Center(
              child: Text(
                "Login Screen",
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

                SizedBox(height: 25),

                RoundButton(
                  title: "Login",
                  loading: loading,

                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    if (_formkey.currentState!.validate()) {
                      login();
                    }
                  },
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RoutesName.signUp);
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(color: AppColor.tealColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.phone);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColor.tealColor),
                    ),
                    child: Center(child: Text("login with phone")),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
