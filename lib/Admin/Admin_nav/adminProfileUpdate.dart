// ignore_for_file: prefer_const_constructors

import 'package:blood_bank/Admin/adminHomePage.dart';
import 'package:blood_bank/Homepage/Nav/profile_screen.dart';
import 'package:blood_bank/Homepage/home_page.dart';
import 'package:blood_bank/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../adminModel.dart';

class AdminUpdateProfile extends StatefulWidget {
  const AdminUpdateProfile({super.key});

  @override
  State<AdminUpdateProfile> createState() => _AdminUpdateProfile();
}

class _AdminUpdateProfile extends State<AdminUpdateProfile> {
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var usernameController = TextEditingController();
  var contactController = TextEditingController();
  var statusController = TextEditingController();
  var locationController = TextEditingController();

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

  String? wordLimit(value) {
    if (value!.isEmpty) {
      return "Required";
    } else if (value.length > 30) {
      return "Maximum 30 digit";
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

  String? privateNumber(value) {
    if (value!.isEmpty) {
      return "Required";
    } else if (value.length > 10) {
      return "Maximum 10 digit";
    } else {
      return null;
    }
  }

  var myAdmin = AdminModel();

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
        email = userDoc.get('email');
        contact = userDoc.get('contact');
        status = userDoc.get("status");
        location = userDoc.get("location");

        // location = userDoc.get("location");
        // debugPrint(name);
      });
      usernameController = TextEditingController(text: name);
      contactController = TextEditingController(text: contact);
      locationController = TextEditingController(text: location);
      statusController = TextEditingController(text: status);
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong try again later!");
      // print(e);
    }
  }

  void updateData() {
    User? user = _auth.currentUser;
    uid = user!.uid;
    try {
      FirebaseFirestore.instance.collection('admin').doc(uid).update({
        'username': usernameController.text.trim(),
        'contact': contactController.text.trim(),
        'status': statusController.text.trim(),
        'location': locationController.text.trim(),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
        title: const Text(
          'Update Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          child: Column(
            children: [
              SizedBox(
                height: 35,
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset("images/Login.png", scale: 0.5),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "  Change your details ",
                style: TextStyle(
                  color: Color.fromARGB(255, 68, 68, 130),
                  fontSize: 20,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 0),
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
                      //location
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          controller: locationController,
                          // initialValue: bloodType,
                          onSaved: (value) {
                            locationController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.location_city),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "Location"),
                          validator: wordLimit,
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
                                  return AdminHomePage();
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
