import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:flutter/material.dart';
import 'package:project_firebase/Routes/routes_name.dart';
import 'package:project_firebase/utils/Utils.dart';
import 'package:project_firebase/widgets/app_color.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ref = FirebaseDatabase.instance.ref("Honda");
  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final serachFilter = TextEditingController();
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
        backgroundColor: AppColor.tealColor,
        title: Center(
          child: Text(
            "Post Screen",
            style: TextStyle(color: AppColor.whiteColor),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: serachFilter,
              decoration: InputDecoration(
                hintText: 'Search',

                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              itemBuilder: (context, snapshot, index, animation) {
                final title = snapshot.child('title').value.toString();
                if (serachFilter.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {
                              showMyDialog(
                                title,
                                snapshot.child('id').value.toString(),
                              );
                            },

                            leading: Icon(Icons.edit),
                            title: Text("edit"),
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              ref
                                  .child(snapshot.child('id').value.toString())
                                  .remove();
                            },
                            leading: Icon(Icons.delete),
                            title: Text("Delete"),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (title.toLowerCase().contains(
                  serachFilter.text.toLowerCase().toString(),
                )) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutesName.add);
        },
        child: Center(
          child: Icon(Icons.arrow_forward, color: AppColor.tealColor),
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
                Navigator.pop(context);
              },
              child: Text("cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ref
                    .child(id)
                    .update({'title': editController.text.toString()})
                    .then((value) {
                      Utils().toastMessage("post updated suucesfully");
                    })
                    .onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
              },

              child: Text("update"),
            ),
          ],
        );
      },
    );
  }
}
