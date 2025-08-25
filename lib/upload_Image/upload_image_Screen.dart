import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_firebase/utils/Utils.dart';
import 'package:project_firebase/widgets/Round_button.dart';
import 'package:project_firebase/widgets/app_color.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebaseStorage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref("Honda");
  Future getGalleryImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image Picked");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.deepColor,
        title: Center(
          child: Text(
            "Upload Image Screen",
            style: TextStyle(color: AppColor.whiteColor, fontSize: 20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: _image != null
                    ? Image.file(_image!.absolute)
                    : Center(child: Icon(Icons.image)),
              ),
            ),
            SizedBox(height: 35),
            RoundButton(
              title: "Upload image here",
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true;
                });
                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage
                    .instance
                    .ref(
                      "/foldername/" +
                          DateTime.now().millisecondsSinceEpoch.toString(),
                    );
                firebaseStorage.UploadTask uploadTask = ref.putFile(
                  _image!.absolute,
                );
                Future.value(uploadTask)
                    .then((value) async {
                      var newUrl = await ref.getDownloadURL();
                      databaseRef
                          .child("1")
                          .set({'id': "70309", 'title': newUrl.toString()})
                          .then((value) {
                            setState(() {
                              loading = false;
                            });
                          });
                      Utils().toastMessage("Image uploaded");
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
