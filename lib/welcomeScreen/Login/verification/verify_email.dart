// ignore: file_names
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../User/Homepage/home_page.dart';
import '../loginPage/login.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

//verifed?
  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

//send -> email verification
  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

// frontend and ?
  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const HomePage()
      : Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "  Email Verification ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 68, 68, 130),
                    fontSize: 22,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'images/verification.png',
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                  child: Column(
                    children: [
                      const Text(
                        "Check your Email to verify the account.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                        onPressed:
                            canResendEmail ? sendVerificationEmail : null,
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          backgroundColor:
                              const Color.fromRGBO(254, 109, 115, 1),
                        ),
                        child: const Text(
                          "Resend Email",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const LoginPage();
                          },
                        )),
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 70, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          backgroundColor:
                              const Color.fromRGBO(254, 109, 115, 1),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
}
