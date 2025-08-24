import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:project_firebase/Routes/routes_name.dart';
import 'package:project_firebase/utils/Utils.dart';

import 'package:project_firebase/widgets/app_color.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final fireStore = FirebaseFirestore.instance.collection("Salman").snapshots();
  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  CollectionReference ref = FirebaseFirestore.instance.collection("Salman");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.pushNamed(context, RoutesName.login);
              });
            },
            icon: Icon(Icons.logout_outlined, color: AppColor.whiteColor),
          ),
        ],
        backgroundColor: AppColor.deepColor,
        title: Center(
          child: Text(
            "Firestore Screen",
            style: TextStyle(color: AppColor.whiteColor),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: fireStore,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) return Text("Some Error");
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {},
                          title: Text(
                            snapshot.data!.docs[index]['title'].toString(),
                          ),
                          subtitle: Text(
                            snapshot.data!.docs[index]['Id'].toString(),
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: ListTile(
                                  onTap: () {
                                    showMyDialog(
                                      editController.text,
                                      snapshot.data!.docs[index]['Id']
                                          .toString(),
                                    );
                                  },
                                  leading: Icon(Icons.edit),
                                  title: Text("edit here"),
                                ),
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text("Delete"),
                                  onTap: () {
                                    showMyDialog(
                                      editController.text,
                                      snapshot.data!.docs[index]['Id']
                                          .toString(),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutesName.fireData);
        },
        child: Center(
          child: Icon(Icons.arrow_forward, color: AppColor.deepColor),
        ),
      ),
    );
  }

  Future<void> showMyDialog(String titile, id) async {
    editController.text = titile;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: InputDecoration(hintText: "edit"),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.doc(id).delete();

                Navigator.pop(context);
              },
              child: Text("cancel"),
            ),
            TextButton(
              onPressed: () {
                ref
                    .doc(id)
                    .update({'title': editController.text.toString()})
                    .then((value) {
                      Utils().toastMessage("Node Updated");
                    })
                    .onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                Navigator.pop(context);
              },

              child: Text("update"),
            ),
          ],
        );
      },
    );
  }
}
