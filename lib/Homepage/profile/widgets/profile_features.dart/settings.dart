// ignore_for_file: use_build_context_synchronously

import 'package:blood_bank/loginPage/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../model/user_model.dart';
import '../profile_menu.dart';
import 'change_pass.dart';

class SettingProfile extends StatefulWidget {
  const SettingProfile({super.key});

  @override
  State<SettingProfile> createState() => _SettingProfileState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
var myUser = UserModel();

Future deleteUserData() async {
  User? user = _auth.currentUser;
  String uid = user!.uid;
  try {
    CollectionReference data = FirebaseFirestore.instance.collection('users');
    return data.doc(uid).delete().then((value) {
      deleteUser();
    });
  } catch (e) {
    Fluttertoast.showToast(msg: "Something went wrong try again later!");
  }
}

Future deleteUser() async {
  User? user = _auth.currentUser;
  try {
    await user!.delete().then((value) {
      Fluttertoast.showToast(msg: "Your Account is deleted!");
    });
  } catch (e) {
    Fluttertoast.showToast(msg: "Something went wrong try again later!");
  }
}

void deleteAccount(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Delete Account',
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
              Text('Are you sure want to delete your account?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              deleteUserData();
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const LoginPage();
                },
              ));
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
// ignore: non_constant_identifier_names

class _SettingProfileState extends State<SettingProfile> {
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
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const Text(
            " Settings ",
            style: TextStyle(
              color: Color.fromARGB(255, 68, 68, 130),
              fontSize: 22,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          //menu
          ProfileMenuWidget(
            title: "Change Password",
            icon: Icons.lock,
            onPress: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const ProfileForgetPass();
              },
            )),
          ),
          ProfileMenuWidget(
            title: "Delete Account",
            icon: LineAwesomeIcons.remove_user,
            onPress: () {
              deleteAccount(context);
            },
          ),
        ],
      )),
    );
  }
}
