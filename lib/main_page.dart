import 'package:blood_bank/verification/verify_email.dart';
import 'package:blood_bank/welcomeScreen/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // print(snapshot);
            return const VerifyEmail();
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
