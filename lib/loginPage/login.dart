// ignore_for_file: prefer_const_constructors, sort_child_properties_last
import 'package:blood_bank/signUp/accept_terms.dart';
import 'package:blood_bank/verification/verify_email.dart';
import 'package:blood_bank/verification/forgotpassword.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Admin/adminHomePage.dart';
import '../Homepage/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //text controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ignore: prefer_typing_uninitialized_variables
  var _isObscured;

  @override
  void initState() {
    emailController.addListener(() {
      setState(() {});
    });
    super.initState();
    _isObscured = true;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget buildEmail() {
    return Material(
      elevation: 3.5,
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(30)),
      shadowColor: Colors.black,
      child: TextField(
        textInputAction: TextInputAction.next,
        controller: emailController,
        obscureText: false,
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
                borderSide:
                    BorderSide(color: Color.fromRGBO(255, 203, 205, 1))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide:
                    BorderSide(color: Color.fromRGBO(255, 203, 205, 1))),
            hintText: 'Email',
            hintStyle: TextStyle(
                color: Color.fromARGB(150, 68, 68, 130), fontSize: 15),
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
      child: TextFormField(
        textInputAction: TextInputAction.done,
        controller: passwordController,
        obscureText: _isObscured,
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(
          color: Color.fromARGB(255, 68, 68, 130),
          fontSize: 14,
        ),
        decoration: InputDecoration(
            suffixIcon: IconButton(
              padding: const EdgeInsetsDirectional.only(end: 12.0),
              color: Color.fromARGB(255, 68, 68, 130),
              icon: _isObscured
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
            ),
            filled: true,
            fillColor: Color.fromRGBO(255, 203, 205, 1),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide:
                    BorderSide(color: Color.fromRGBO(255, 203, 205, 1))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide:
                    BorderSide(color: Color.fromRGBO(255, 203, 205, 1))),
            hintText: 'Password',
            hintStyle: TextStyle(
                color: Color.fromARGB(150, 68, 68, 130), fontSize: 15),
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
              fontWeight: FontWeight.bold,
            ),
          ),

          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) {
                  return ForgetPass();
                }),
              ),
            );
          },
          //padding: EdgeInsets.only(right: 0),
        ));
  }

  Widget signUp(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don’t have an Account ?"),
        TextButton(
            child: Text(
              "Sign Up ",
              style: TextStyle(
                color: Color.fromARGB(255, 68, 68, 130),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) {
                    return Terms();
                  }),
                ),
              );
            }
            //padding: EdgeInsets.only(right: 0),
            ),
      ],
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

  void checkRole() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      var check = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot.get('role') == "Admin") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminHomePage(),
              ),
            );
          } else if (documentSnapshot.get('role') == "User") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          }
        } else {
          errorPass();
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong try again later!");
      // print(e);
    }
  }

  void signUserIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      checkRole();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        errorEmail();
      } else if (e.code == 'wrong-password') {
        errorPassword();
      } else if (e.code == 'user-not-found') {
        errorPass();
      } else {
        Fluttertoast.showToast(msg: "Something went wrong try again later!");
      }
    }
  }

  void check() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email == '' || password == '') {
      fill();
    } else {
      signUserIn(email, password);
    }
  }

  void fill() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Enter Email and Password",
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
                  backgroundColor: Color.fromRGBO(254, 109, 115, 1),
                ),
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void errorEmail() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Invalid Email",
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
                  backgroundColor: Color.fromRGBO(254, 109, 115, 1),
                ),
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void errorPassword() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Incorrect Password",
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
                  backgroundColor: Color.fromRGBO(254, 109, 115, 1),
                ),
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void errorPass() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Account doesn't Exist",
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
                  backgroundColor: Color.fromRGBO(254, 109, 115, 1),
                ),
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // This will prevent the user from navigating back
      },
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
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
                  Image.asset("images/Login.png", scale: 0.5),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: Column(children: [
                      buildEmail(),
                      SizedBox(
                        height: 20,
                      ),
                      buildPassword(),
                      buildForgotPassword(context),
                      //buildLoginBtn(context),
                      SizedBox(
                        width: 350,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: check,
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: Color.fromRGBO(254, 109, 115, 1),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      signUp(context),
                      orLine(),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
