// ignore_for_file: unused_catch_clause, use_build_context_synchronously, unused_field, avoid_print

import 'dart:async';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../Admin/utils/app_color.dart';
import '../../../Login/loginPage/login.dart';
import '../profile/update_profile_screen.dart';
import '../profile/widgets/profile_features.dart/settings.dart';
import '../profile/widgets/profile_menu.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const id = 'set_photo_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String name = '...';
  String uid = '';
  String bloodType = '...';
  String email = "...";
  String contact = "...";
  String location = '...';
  String image = '';
  String status = "I am a new user";
  // DataController? dataController;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    getData();
  }

  Future<void> getData() async {
    User? user = _auth.currentUser;
    uid = user!.uid;
    // dataController = Get.find<DataController>();
    try {
      debugPrint("user.uid $uid");

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (mounted) {
        setState(() {
          name = userDoc.get('username');
          bloodType = userDoc.get('bloodType');
          email = userDoc.get('email');
          contact = userDoc.get('contact');
          location = userDoc.get('location');
          status = userDoc.get('status');
          image = userDoc.get('image');
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong try again later!");
      print(e);
    }
  }

  void logoutButton(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Account Logout',
            style: TextStyle(
              color: Color.fromARGB(255, 68, 68, 130),
              fontSize: 20,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              letterSpacing: 0,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure want to Logout from your account?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                logout(context);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  File? _image;

  String? e;

  File? profileImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
          title: const Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 120,
                        height: 120,
                        margin: const EdgeInsets.only(top: 35),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(70),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(254, 109, 115, 1),
                              Color.fromRGBO(254, 109, 115, 1),
                              Color.fromRGBO(254, 109, 115, 1),
                              Color.fromRGBO(254, 109, 115, 1),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: image.isEmpty
                                  ? const CircleAvatar(
                                      radius: 56,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                          'https://cdn1.iconfinder.com/data/icons/user-pictures/100/unknown-512.png'))
                                  : CircleAvatar(
                                      radius: 56,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                        image,
                                      )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 0,
                      height: 10,
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 25,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 68, 68, 130)),
                  ),
                  const SizedBox(
                    width: 0,
                  ),
                  SizedBox(
                    width: 20,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      iconSize: 20,
                      color: const Color.fromRGBO(254, 109, 115, 1),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UpdateProfileScreen()));
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 5,
              ),

              Padding(
                // height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: Text(
                  '" $status "',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 68, 68, 130),
                      fontFamily: 'Poppins'),
                ),
              ),
              // Container(
              //   width: 200,
              //   height: 100,
              //   decoration: const BoxDecoration(
              //     borderRadius: BorderRadius.all(Radius.circular(50)),
              //     boxShadow: [
              //       BoxShadow(
              //           color: Colors.grey, //New
              //           blurRadius: 25.0,
              //           offset: Offset(0, -10))
              //     ],
              //   ),
              // ),
              SizedBox(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  height: 250,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(254, 109, 115, 1),
                        width: 1.5),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xffDDDDDD),
                        blurRadius: 4.0,
                        spreadRadius: 3.0,
                        offset: Offset(01, 0.0),
                      )
                    ],
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 0),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: 'Personal Information\n\n',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 68, 68, 130),
                              fontFamily: 'Poppins'),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Email             :  $email\n',
                                style: const TextStyle(height: 2)),
                            TextSpan(
                              text: 'Blood Type  :  $bloodType\n',
                              style: const TextStyle(height: 2),
                            ),
                            TextSpan(
                              text: 'Location       :  $location\n',
                              style: const TextStyle(height: 2),
                            ),
                            TextSpan(
                              text: 'Contact       :  $contact\n',
                              style: const TextStyle(height: 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //menu
              ProfileMenuWidget(
                title: "Contacts",
                icon: Icons.phone,
                onPress: () {},
              ),

              ProfileMenuWidget(
                title: "Settings",
                icon: LineAwesomeIcons.cog,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingProfile()));
                },
              ),

              ProfileMenuWidget(
                title: "Logout",
                icon: LineAwesomeIcons.alternate_sign_out,
                onPress: () {
                  logoutButton(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const LoginPage()));
}
