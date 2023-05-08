// ignore_for_file: unused_catch_clause, use_build_context_synchronously, unused_field, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../model and utils/controller/data_controller.dart';
import '../../../model and utils/controller/feed_controller.dart';
import '../../../model and utils/utils/app_color.dart';
import '../../../welcomeScreen/Login/loginPage/login.dart';

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
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 120,
                        height: 120,
                        margin: const EdgeInsets.only(top: 15),
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
                      height: 5,
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
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Text(
                  '" $status "',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 68, 68, 130),
                      fontFamily: 'Poppins'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Personal Information',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color.fromRGBO(254, 109, 115, 1)),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 340,
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
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 68, 68, 130),
                                fontFamily: 'Poppins',
                                height: 3),
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Email :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromRGBO(254, 109, 115, 1),
                                ),
                              ),
                              TextSpan(
                                  text: '\n$email\n',
                                  style: const TextStyle(height: 0)),
                              const TextSpan(
                                text: 'Blood Type :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromRGBO(254, 109, 115, 1),
                                ),
                              ),
                              TextSpan(
                                text: '\n$bloodType\n',
                                style: const TextStyle(height: 0),
                              ),
                              const TextSpan(
                                text: 'Location :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromRGBO(254, 109, 115, 1)),
                              ),
                              TextSpan(
                                text: '\n$location\n',
                                style: const TextStyle(height: 0),
                              ),
                              const TextSpan(
                                text: 'Contact :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromRGBO(254, 109, 115, 1)),
                              ),
                              TextSpan(
                                text: '\n$contact\n',
                                style: const TextStyle(height: 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // //menu
              // ProfileMenuWidget(
              //   title: "Contacts",
              //   icon: Icons.phone,
              //   onPress: () {},
              // ),

              ProfileMenuWidget(
                title: "Settings",
                icon: LineAwesomeIcons.cog,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingProfile()));
                },
              ),

              // ProfileMenuWidget(
              //   title: "Logout",
              //   icon: LineAwesomeIcons.alternate_sign_out,
              //   onPress: () {
              //     logoutButton(context);
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}
