import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../loginPage/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: signUserOut ,
            icon: Icon(Icons.logout),
          )
        ],
      ),
          body: Center(child: Text("Logged in")),
    );
  }
}
