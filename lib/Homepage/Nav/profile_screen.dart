// ignore_for_file: unused_catch_clause, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:blood_bank/Homepage/profile/update_profile_screen.dart';
import 'package:blood_bank/Homepage/profile/widgets/profile_features.dart/select_photo.dart';
import 'package:blood_bank/Homepage/profile/widgets/profile_features.dart/settings.dart';
import 'package:blood_bank/Homepage/profile/widgets/profile_menu.dart';
import 'package:blood_bank/welcomeScreen/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../loginPage/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const id = 'set_photo_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String name = '...';
  String uid = '';
  String bloodType = '...';
  String email = "...";
  String contact = "...";
  String location = '...';
  // String imagePath = '...';
  String status = "I am a new user";
  Timer? timer;

  @override
  void initState() {
    super.initState();

    getData();
  }

  Future<void> getData() async {
    User? user = _auth.currentUser;
    uid = user!.uid;
    try {
      debugPrint("user.uid $uid");
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!mounted) {
        return;
      }
      setState(() {
        name = userDoc.get('username');
        bloodType = userDoc.get('bloodType');
        email = userDoc.get('email');
        contact = userDoc.get('contact');
        location = userDoc.get('location');
        status = userDoc.get('status');
        // imagePath = userDoc.get('imagepath');
        // debugPrint(email);
        // debugPrint(location);
      });
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

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      if (!mounted) {
        return;
      }
      setState(() {
        _image = img;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      // print(e);
      Navigator.of(context).pop();
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, imagePathController) {
            return SingleChildScrollView(
              controller: imagePathController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImage,
              ),
            );
          }),
    );
  }

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
                height: 15,
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                  child: Center(
                      child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _showSelectPhotoOptions(context);
                    },
                    child: Center(
                        child: Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(254, 109, 115, 1),
                      ),
                      child: Center(
                          child: _image == null
                              ? const Text(
                                  'No image selected',
                                  style: TextStyle(fontSize: 20),
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(_image!),
                                  radius: 200,
                                )),
                    )),
                  ))),

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
