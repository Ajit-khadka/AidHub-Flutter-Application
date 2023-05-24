// ignore_for_file: depend_on_referenced_packages, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'comment.dart';
import 'package:intl/intl.dart';

class CommentPage extends StatefulWidget {
  DocumentSnapshot eventData, user;
  CommentPage(this.eventData, this.user, {super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

FirebaseAuth auth = FirebaseAuth.instance;
String username = '...';
String uid = '';
String image = '';
final _commentTextController = TextEditingController();

class _CommentPageState extends State<CommentPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(245, 243, 241, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
          title: const Text(
            'Comment Page',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: showCommentDialog,
          backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
          child: const Icon(Icons.comment_rounded),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("feeds")
                        .doc(widget.eventData.id)
                        .collection("comments")
                        .orderBy("CommentTime", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      //loading
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No comments',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 68, 68, 130),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot data =
                                  snapshot.data!.docs[index];
                              return Comment(
                                text: data["CommentText"].toString(),
                                user: data["CommentBy"].toString(),
                                time: data["CommentTime"].toString(),
                                image: data["image"].toString(),
                              );
                            });
                      }
                      return const Center();
                    }),
              ),
            ],
          ),
        ));
  }

  dateFormat() {
    DateTime now = DateTime.now();

    // Format the date as desired
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    // print(formattedDate);
    return formattedDate;
  }

//add comment
  Future<void> addComment(
    String commentText,
  ) async {
    User? user = auth.currentUser;
    uid = user!.uid;
    // debugPrint("user.uid $uid");
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    username = userDoc.get('username');
    image = userDoc.get("image");
    // print("commentText: " + commentText);

    FirebaseFirestore.instance
        .collection("feeds")
        .doc(widget.eventData.id)
        .collection("comments")
        .add({
      "CommentText": commentText,
      "CommentBy": username,
      "CommentTime": dateFormat(),
      "image": image,
    });
  }

  void fill() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Comment cannot be empty",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 68, 68, 130),
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
                ),
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

//show comment
  void showCommentDialog() {
    // print(widget.eventData.id);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "Add Comment",
                style: TextStyle(
                  color: Color.fromARGB(255, 68, 68, 130),
                  fontSize: 20,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                ),
              ),
              content: TextFormField(
                controller: _commentTextController,
                decoration: const InputDecoration(
                  hintText: "Write a comment...",
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (_commentTextController.text.trim().isNotEmpty) {
                        addComment(_commentTextController.text);
                        _commentTextController.clear();
                      } else {
                        fill();
                      }
                    },
                    child: const Text("Post")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _commentTextController.clear();
                    },
                    child: const Text("Cancel"))
              ],
            ));
  }
}
