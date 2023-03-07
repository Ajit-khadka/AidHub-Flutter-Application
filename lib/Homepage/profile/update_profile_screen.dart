// ignore_for_file: prefer_const_constructors

import 'package:blood_bank/Homepage/profile/profile_screen.dart';
import 'package:blood_bank/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // final _emailController = TextEditingController();
  final usernameController = TextEditingController();
  final bloodController = TextEditingController();
  final contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final statusController = TextEditingController();

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

  String? featureLen(value) {
    if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
      return "Not a valid Feature";
    } else if (value.length < 6) {
      return "Minimum 6 letter";
    } else if (value.length > 20) {
      return "Maximum 20 letter";
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

  var myUser = UserModel();

  String name = '...';
  String uid = '';
  String bloodType = '...';
  String email = "...";
  String contact = "...";
  String password = "...";
  String status = "...";
  String location = "...";

  Future getUserInfo() async {
    User? user = _auth.currentUser;
    uid = user!.uid;
    try {
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        name = userDoc.get('username');
        bloodType = userDoc.get('bloodType');
        email = userDoc.get('email');
        contact = userDoc.get('contact');
        status = userDoc.get("status");
        // location = userDoc.get("location");
        // debugPrint(name);
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong try again later!");
      // print(e);
    }
  }

  void updateData() {
    User? user = _auth.currentUser;
    uid = user!.uid;
    try {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'username': usernameController.text.trim(),
        'bloodType': bloodController.text.trim(),
        'contact': contactController.text.trim(),
        'status': statusController.text.trim(),
      }).then((value) {
        Fluttertoast.showToast(msg: "Your profile is updated");
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong try again later!");
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color.fromRGBO(254, 109, 115, 1)),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
          child: Column(
            children: [
              const Text(
                "  Update Profile ",
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
              Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: const Image(
                                  image: AssetImage('images/avatar.jpg'),
                                )),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color.fromRGBO(254, 109, 115, 1),
                                ),
                                child: const Icon(
                                  LineAwesomeIcons.camera,
                                  size: 20,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "Change your details.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      //status
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: TextFormField(
                          controller: statusController,
                          // initialValue: status,
                          onSaved: (value) {
                            statusController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          validator: featureLen,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.face),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "Feature"),
                        ),
                      ),

                      //Username
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          controller: usernameController,
                          // initialValue: name,
                          // ..text = "${Get.arguments['username'].toString()}",
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
                              return "Min 5 character";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "Username"),
                        ),
                      ),
                      //bloodType
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          controller: bloodController,
                          // initialValue: bloodType,
                          onSaved: (value) {
                            bloodController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.bloodtype),
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
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          controller: contactController,
                          // initialValue: contact,
                          onSaved: (value) {
                            contactController.text = value!;
                          },
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "Contact"),
                          validator: privateNumber,
                        ),
                      ),

                      //edit button
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 25.0,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              updateData();
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const ProfileScreen();
                                },
                              ));
                            }
                          },
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
                          child: Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
