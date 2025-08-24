import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_firebase/utils/Utils.dart';
import 'package:project_firebase/widgets/Round_button.dart';
import 'package:project_firebase/widgets/app_color.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final databaseReference = FirebaseDatabase.instance.ref("Honda");
  bool loading = false;
  final postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        shadowColor: AppColor.whiteColor,
        backgroundColor: AppColor.tealColor,
        title: Center(
          child: Text(
            "Add post here",
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
                databaseReference
                    .child(id)
                    .set({'title': postController.text.toString(), 'id': id})
                    .then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage("Post added suucesfully");
                    })
                    .onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(error.toString());
                    });
                {}
              },
            ),
          ],
        ),
      ),
    );
  }
}
