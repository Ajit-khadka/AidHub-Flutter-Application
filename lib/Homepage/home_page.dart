// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../loginPage/login.dart';
import '../user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed:(){
              logout(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
                children: const <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Home,",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'OpenSans',

                      ),

    ),
                      // Text('${loggedInUser.userName}'
                      //   style: TextStyle(
                      //   fontSize: 36,
                      //   fontFamily: 'OpenSans',
                      //   fontWeight: FontWeight.bold,
                      // )



                   ),
    ],
            ),
    )
          ),
    );
  }
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}
