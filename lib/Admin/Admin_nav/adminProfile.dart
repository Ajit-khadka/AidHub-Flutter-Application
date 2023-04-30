// ignore_for_file: unused_catch_clause, use_build_context_synchronously, prefer_interpolation_to_compose_strings, depend_on_referenced_packages, library_prefixes, unused_import, file_names, avoid_print, unused_field

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:path/path.dart' as Path;



import '../../User/Homepage/profile/widgets/profile_features.dart/settings.dart';
import '../../User/Homepage/profile/widgets/profile_menu.dart';
import '../../model and utils/controller/data_controller.dart';
import '../../model and utils/controller/feed_controller.dart';
import '../../model and utils/utils/app_color.dart';
import '../../welcomeScreen/Login/loginPage/login.dart';
import '../Admin Profile/Employeelist/employee.dart';
import '../Admin Profile/adminProfileUpdate.dart';


class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  static const id = 'set_photo_screen';

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String name = '...';
  String uid = '';
  String bloodType = '...';
  String email = "...";
  String contact = "...";
  String location = '...';
  String role = '...';
  String image =
      'https://cdn1.iconfinder.com/data/icons/user-pictures/100/unknown-512.png';
  String status = "I am a new user";
  Timer? timer;

  DataController? dataController;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    User? user = _auth.currentUser;
    uid = user!.uid;
    dataController = Get.find<DataController>();

    try {
      debugPrint("user.uid $uid");
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (mounted) {
        setState(() {
          name = userDoc.get('username');
          email = userDoc.get('email');
          contact = userDoc.get('contact');
          location = userDoc.get('location');
          status = userDoc.get('status');
          image = userDoc.get('image');
          role = userDoc.get('role');
          debugPrint(name);
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
                                      backgroundImage:
                                          AssetImage('images/DefaultUser.png'))
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
                            builder: (context) => const AdminUpdateProfile()));
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
                                text: 'Role',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromRGBO(254, 109, 115, 1),
                                ),
                              ),
                              TextSpan(
                                  text: '\n$role\n',
                                  style: const TextStyle(height: 0)),
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

              //menu
              ProfileMenuWidget(
                title: "Employees",
                icon: Icons.local_hospital,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EmployeeList()));
                },
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
  Get.delete<DataController>(force: true);
  Get.delete<FeedController>(force: true);
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const LoginPage()));
}
