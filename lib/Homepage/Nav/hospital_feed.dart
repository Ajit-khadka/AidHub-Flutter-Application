import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HospitalFeed extends StatefulWidget {
  const HospitalFeed({super.key});

  @override
  State<HospitalFeed> createState() => _HospitalFeedState();
}

class _HospitalFeedState extends State<HospitalFeed> {
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
    debugPrint("user.uid $uid");
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        child: RichText(
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
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
