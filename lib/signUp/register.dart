// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:blood_bank/Homepage/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../user_model.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => Register();
}

Widget text(BuildContext context) {
  return Center(
    child: Column(
      children: const [
        // SizedBox(
        //   height: 0,
        // ),
        Text(
          "  SIGNUP ",
          style: TextStyle(
            color: Color.fromARGB(255, 68, 68, 130),
            fontSize: 20,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          "Create an account it's Free",
          style: TextStyle(
              color: Color.fromARGB(255, 68, 68, 130),
              fontSize: 10,
              fontFamily: 'OpenSans'),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    ),
  );
}

class Register extends State<SignIn> {

  GlobalKey<FormState> formkey = GlobalKey<FormState>();


  String? requiredPass(value) {
    if (value.length < 6) {
      return "Minimum 6 digit";
    } else if (value.length > 10) {
      return "Maximum 10 digit";
    } else {
      return null;
    }
  }

  String? requiredPass1(value) {
    if (value.length < 6) {
      return "Minimum 6 digit";
    } else if (value.length > 10) {
      return "Maximum 10 digit";
    } else if (_confirmPasswordController.text != _passwordController.text) {
      return "Password don't match";
    } else {
      return null;
    }
  }


  String? privateNumber(value) {
    if (value!.isEmpty) {
      return "Required";
    } else if (value.length > 10) {
      return "Maximum 10 digit";
    } else {
      return null;
    }
  }

  final _emailController = TextEditingController();
  final usernameController = TextEditingController();
  final bloodController = TextEditingController();
  final contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? errorMessage;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Color.fromRGBO(254, 109, 115, 1)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
      ),
      //resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
          child: Center(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  text(context),
                  //email
                  TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        _emailController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Email", labelStyle: TextStyle(),
                      ),

                      validator: (value) {
                        if (value!.isEmpty || !RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!)) {
                          return "Not a valid Email";
                        } else {
                          return null;
                        }
                      }
                  ),
                  //Username
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: usernameController,
                      onSaved: (value) {
                        usernameController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(
                            value!)) {
                          return "Not a valid Username";
                        }
                        if (!RegExp(r'^.{5,}$').hasMatch(value!)) {
                          return "Min 5 character";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ), labelText: "Username"),

                    ),
                  ),
                  //bloodType
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: bloodController,
                      onSaved: (value) {
                        bloodController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.bloodtype),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Blood Type"),
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Required"),
                      ]),
                    ),
                  ),
                  //contact
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: contactController,
                      onSaved: (value) {
                        contactController.text = '+977' + value!;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ), labelText: "Contact"),
                      validator: privateNumber,
                    ),
                  ),
                  //password
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: _passwordController,
                      onSaved: (value) {
                        _passwordController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ), labelText: "Password"),
                      validator: requiredPass,
                    ),
                  ),
                  //confirmPassword
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      onSaved: (value) {
                        _confirmPasswordController.text = value!;
                      },
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),),
                          labelText: "Confirm Password"),
                      validator: requiredPass1,
                    ),
                  ),
                  //signup button
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25.0,
                    ),
                    child: ElevatedButton(
                      child: Text(
                        "Signup",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        register(
                            _emailController.text, _passwordController.text);
                        debugPrint(contactController.text);

                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        padding: EdgeInsets.symmetric(
                            horizontal: 120, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Color.fromRGBO(254, 109, 115, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future register(String email, String password) async {
    if (formkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email, password: password);
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }

        Fluttertoast.showToast(msg: errorMessage!);
        debugPrint(error.code);
      }
      postDetailsToServer();
    }

  }
    Future postDetailsToServer() async {
      //calling firebase, user model then sending values

      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;

      UserModel userModel = UserModel();

      // writing all the values
      userModel.email = user!.email;
      userModel.uid = user.uid;
      userModel.userName = usernameController.text;
      userModel.bloodType = bloodController.text;
      userModel.contact = '+977${contactController.text}';
      userModel.password = _passwordController.text;
      userModel.confirmPass = _confirmPasswordController.text;

      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(userModel.toMap());
      Fluttertoast.showToast(msg: "Account created successfully :) ");

      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false);
    }
  }

