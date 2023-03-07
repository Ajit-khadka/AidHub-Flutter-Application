// ignore_for_file: prefer_const_constructors

import 'package:blood_bank/loginPage/login.dart';
import 'package:blood_bank/signUp/register.dart';
import 'package:flutter/material.dart';

class Terms extends StatefulWidget {
  const Terms({super.key});

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color.fromRGBO(254, 109, 115, 1)),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(children: [
            Text(
              "  Blood Bank Updates ",
              style: TextStyle(
                color: Color.fromARGB(255, 68, 68, 130),
                fontSize: 22,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            const Text(
              "By Agreeing, you have accepted Blood Bank's updated Terms of Use and Privacy Policy. Blood Bank will use your data in the ways outlined in our Terms of Use and Privacy Policy. Blood Bank uses donation terms of Nepal Red Cross Society. If you Disagree, you cannot access Blood Bank's features. \n\nTerms and policy can be changed accordingly when breaches are found in system, However, User can lose their data and cannot change thier password if either :  \n\n 1. Deletes thier account \n2. Deletes their Email.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SignIn();
                }),
              ),
              child: const Text(
                "Agree",
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
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return LoginPage();
                },
              )),
              style: ElevatedButton.styleFrom(
                elevation: 5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
              ),
              child: const Text(
                "Disagree",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
