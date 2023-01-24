// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

import '../forgotpage/forgotpage.dart';
import '../signUp/register.dart';

class Testpage extends StatefulWidget {
  const Testpage({super.key});

  @override
  State<Testpage> createState() => TestpageState();
}

Widget buildEmail() {
  return Material(
    elevation: 3.5,
    color: Colors.transparent,
    borderRadius: BorderRadius.all(Radius.circular(30)),
    shadowColor: Colors.black,
    child: TextField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Color.fromARGB(255, 68, 68, 130),
        fontSize: 14,
      ),
      decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromRGBO(255, 203, 205, 1),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Color.fromRGBO(255, 203, 205, 1))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Color.fromRGBO(255, 203, 205, 1))),
          hintText: 'Email',
          hintStyle:
              TextStyle(color: Color.fromARGB(150, 68, 68, 130), fontSize: 15),
          prefixIcon: Icon(
            Icons.person,
            color: Color.fromARGB(255, 68, 68, 130),
          )),
    ),
  );
}

Widget buildPassword() {
  return Material(
    elevation: 3.5,
    color: Colors.transparent,
    borderRadius: BorderRadius.all(Radius.circular(30)),
    shadowColor: Colors.black,
    child: TextField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Color.fromARGB(255, 68, 68, 130),
        fontSize: 14,
      ),
      decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromRGBO(255, 203, 205, 1),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Color.fromRGBO(255, 203, 205, 1))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Color.fromRGBO(255, 203, 205, 1))),
          hintText: 'Password',
          hintStyle:
              TextStyle(color: Color.fromARGB(150, 68, 68, 130), fontSize: 15),
          prefixIcon: Icon(
            Icons.lock,
            color: Color.fromARGB(255, 68, 68, 130),
          )),
    ),
  );
}

Widget buildForgotPassword(BuildContext context) {
  return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: Text(
          "Forgot Password ?",
          style: TextStyle(
            color: Color.fromARGB(255, 68, 68, 130),
            fontSize: 12,
          ),
        ),

        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) {
                return ForgotPass();
              }),
            ),
          );
        },
        //padding: EdgeInsets.only(right: 0),
      ));
}

Widget signUp(BuildContext context) {
  return Container(
      alignment: Alignment.center,
      child: TextButton(
          child: Text(
            "Don’t have an Account ? Sign Up ",
            style: TextStyle(
              color: Color.fromARGB(255, 68, 68, 130),
              fontSize: 12,
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) {
                  return SignIn();
                }),
              ),
            );
          }
          //padding: EdgeInsets.only(right: 0),
          ));
}

Widget buildLoginBtn() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 0),
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () => debugPrint("Login Pressed"),
      child: Text(
        "Login",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 5,
        padding: EdgeInsets.all(18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Color.fromRGBO(254, 109, 115, 1),
      ),
    ),
  );
}

Widget orLine() {
  return RichText(
    text: TextSpan(children: const [
      TextSpan(
        text: ("_________________  "),
        style: TextStyle(color: Colors.red),
      ),
      TextSpan(
        text: ("  OR  "),
        style: TextStyle(color: Color.fromARGB(255, 68, 68, 130)),
      ),
      TextSpan(
        text: ("  _________________"),
        style: TextStyle(color: Colors.red),
      ),
    ]),
  );
}

class TestpageState extends State<Testpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(
                  color: Color.fromARGB(255, 68, 68, 130),
                  fontSize: 20,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(
                height: 300,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Column(children: [
                  buildEmail(),
                  SizedBox(
                    height: 20,
                  ),
                  buildPassword(),
                  buildForgotPassword(context),
                  buildLoginBtn(),
                  SizedBox(
                    height: 10,
                  ),
                  signUp(context),
                ]),
              ),
              orLine(),
            ],
          ),
        ),
      ),
    );
  }
}
