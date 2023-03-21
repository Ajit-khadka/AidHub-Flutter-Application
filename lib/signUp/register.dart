// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_typing_uninitialized_variables
import 'package:blood_bank/verification/verify_email.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/user_model.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => Register();
}

Widget text(BuildContext context) {
  return Center(
    child: Column(
      children: const [
        Text(
          "  SIGNUP ",
          style: TextStyle(
            color: Color.fromARGB(255, 68, 68, 130),
            fontSize: 22,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          "Create an account it's free.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black38,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
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

  String? wordLimit(value) {
    if (value!.isEmpty) {
      return "Required";
    } else if (value.length > 30) {
      return "Maximum 30 characters";
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
  final locationController = TextEditingController();

  String? errorMessage;

  var _isObscured;
  var _isObscured1;

  @override
  void initState() {
    super.initState();
    _isObscured = true;
    _isObscured1 = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon:
                Icon(Icons.arrow_back, color: Color.fromRGBO(254, 109, 115, 1)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
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
                        labelText: "Email",
                        labelStyle: TextStyle(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                          return "Not a valid Email";
                        } else {
                          return null;
                        }
                      }),
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
                        if (value!.isEmpty ||
                            !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return "Not a valid Username";
                        }
                        if (!RegExp(r'^.{5,}$').hasMatch(value)) {
                          return "Minimum 5 characters";
                        } else if (value.length > 20) {
                          return ("Maximum 20 characters");
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Username"),
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
                      validator: wordLimit,
                    ),
                  ),
                  //location
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: locationController,
                      onSaved: (value) {
                        locationController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_city),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Location"),
                      validator: wordLimit,
                    ),
                  ),
                  //contact
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: contactController,
                      onSaved: (value) {
                        contactController.text = value!;
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
                          ),
                          labelText: "Contact"),
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
                      obscureText: _isObscured,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            padding:
                                const EdgeInsetsDirectional.only(end: 12.0),
                            icon: _isObscured
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                          ),
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Password"),
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
                      obscureText: _isObscured1,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            padding:
                                const EdgeInsetsDirectional.only(end: 12.0),
                            icon: _isObscured1
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscured1 = !_isObscured1;
                              });
                            },
                          ),
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                        // debugPrint(contactController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        padding:
                            EdgeInsets.symmetric(horizontal: 55, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
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
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "email-already-in-use":
            errorMessage = "Email already exists.";
            break;
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          default:
            errorMessage = "Something went wrong Try again late!";
        }

        Fluttertoast.showToast(msg: errorMessage!);
        debugPrint(error.code);
      }
      postDetailsToServer();
    }
  }

  //store data
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
    userModel.contact = contactController.text;
    userModel.location = locationController.text;
    userModel.status = "I am a new user";
    userModel.image = 'https://cdn1.iconfinder.com/data/icons/user-pictures/100/unknown-512.png';
    userModel.role = "User";

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => VerifyEmail()),
        (route) => false);
  }
}
