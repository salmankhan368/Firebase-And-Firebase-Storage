import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:project_firebase/utils/Utils.dart';

import 'package:project_firebase/widgets/Round_button.dart';
import 'package:project_firebase/widgets/app_color.dart';

class FireStoreData extends StatefulWidget {
  const FireStoreData({super.key});

  @override
  State<FireStoreData> createState() => _FireStoreDataState();
}

class _FireStoreDataState extends State<FireStoreData> {
  bool loading = false;
  final postController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection("Salman");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        shadowColor: AppColor.whiteColor,
        backgroundColor: AppColor.deepColor,
        title: Center(
          child: Text(
            "FireStore DataBAse",
            style: TextStyle(color: AppColor.whiteColor),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30),
            TextFormField(
              controller: postController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            RoundButton(
              title: "Add Now",
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                fireStore
                    .doc(id)
                    .set({'title': postController.text.toString(), 'Id': id})
                    .then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage("Post Added Succefully");
                    })
                    .onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(error.toString());
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
