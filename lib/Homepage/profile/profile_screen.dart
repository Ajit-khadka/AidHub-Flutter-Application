// ignore_for_file: use_build_context_synchronously

import 'package:blood_bank/Homepage/profile/update_profile_screen.dart';
import 'package:blood_bank/Homepage/profile/widgets/profile_features.dart/settings.dart';
import 'package:blood_bank/Homepage/profile/widgets/profile_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../loginPage/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
  String status = "I am a new user";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    User? user = _auth.currentUser;
    uid = user!.uid;
    try {
      // debugPrint("user.uid $uid");
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        name = userDoc.get('username');
        bloodType = userDoc.get('bloodType');
        email = userDoc.get('email');
        contact = userDoc.get('contact');
        status = userDoc.get("status");
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong try again later!");
      // print(e);
    }
  }

  void logoutButton(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color.fromRGBO(254, 109, 115, 1)),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout,
                color: Color.fromRGBO(254, 109, 115, 1)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                        LineAwesomeIcons.alternate_pencil,
                        size: 20,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                ]),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UpdateProfileScreen()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
                    side: BorderSide.none,
                    shape: const StadiumBorder()),
                child: const Text("Edit Profile",
                    style:
                        TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
              ),
            ),

            const SizedBox(
              height: 15,
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
            SizedBox(
              child: Container(
                height: 250,
                width: double.infinity,
                // color: Colors.red,
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromRGBO(254, 109, 115, 1),
                      width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 0),
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
                            text: 'Email             -  $email\n',
                            style: const TextStyle(height: 2)),
                        TextSpan(
                          text: 'Blood Type  -  $bloodType\n',
                          style: const TextStyle(height: 2),
                        ),
                        TextSpan(
                          text: 'Contact       -  $contact\n',
                          style: const TextStyle(height: 2),
                        ),
                      ],
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
    );
  }
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const LoginPage()));
}
