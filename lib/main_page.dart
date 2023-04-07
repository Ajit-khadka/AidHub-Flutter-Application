// ignore_for_file: avoid_print, must_be_immutable

import 'package:blood_bank/Admin/adminHomePage.dart';

import 'package:blood_bank/welcomeScreen/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Login/verification/verify_email.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String role = '...';
  String uid = '';

  void initState() {
    getData();
  }

  Future<void> getData() async {
    User? user = _auth.currentUser;
    uid = user!.uid;
    try {
      // debugPrint("user.uid $uid");
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      role = userDoc.get('role');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (role == 'User') {
              return const VerifyEmail();
            } else if (role == 'Admin') {
              return const AdminHomePage();
            } else {
              return const WelcomeScreen();
            }
          } else if (snapshot.hasError) {
            return const Text("error");
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
