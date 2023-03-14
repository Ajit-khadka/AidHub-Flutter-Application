// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminHospitalFeed extends StatefulWidget {
  const AdminHospitalFeed({super.key});

  @override
  State<AdminHospitalFeed> createState() => _AdminHospitalFeedState();
}

class _AdminHospitalFeedState extends State<AdminHospitalFeed> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String name = '...';
  String uid = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    User? user = _auth.currentUser;
    uid = user!.uid;
    // debugPrint("user.uid $uid");
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    setState(() {
      name = userDoc.get('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
        title: const Text(
          'Hospital Feed',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: 'Hello,\n',
                style: const TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(255, 68, 68, 130),
                    fontFamily: 'Poppins'),
                children: <TextSpan>[
                  TextSpan(
                      text: '$name !',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
