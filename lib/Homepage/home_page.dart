// ignore_for_file: use_build_context_synchronously

import 'package:blood_bank/Homepage/hospital_feed.dart';
import 'package:blood_bank/Homepage/nearest_hospital.dart';
import 'package:blood_bank/Homepage/par_event.dart';
import 'package:blood_bank/Homepage/request.dart';
import 'package:blood_bank/profile/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../loginPage/login.dart';
import '../model/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

var styleList = const TextStyle(color: Colors.white, fontSize: 24);

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  var padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 20);
  double gap = 10;

  int _index = 0;

  List<Widget> widgetsList = const [
    HospitalFeed(),
    BloodRequest(),
    NearestHospital(),
    Events(),
  ];

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: IconButton(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  onPressed: () {
                    {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) {
                            return const ProfileScreen();
                          }),
                        ),
                      );
                    }
                  },
                  icon: const CircleAvatar(
                    backgroundImage: AssetImage("images/avatar.jpg"),
                    radius: 100,
                  )),
            )
          ],
        ),
      ),
      body: PageView.builder(
          itemCount: 4,
          controller: controller,
          onPageChanged: (page) {
            setState(() {
              _index = page;
            });
          },
          itemBuilder: (context, position) {
            return Container(
              child: Center(child: widgetsList[_index]),
            );
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(254, 109, 115, 1),
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(
                  spreadRadius: -10,
                  blurRadius: 60,
                  color: Colors.black.withOpacity(0.4),
                  offset: Offset(0, 25),
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
            child: GNav(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 500),
              tabs: [
                GButton(
                  gap: gap,
                  icon: Icons.home,
                  iconColor: Colors.white,
                  iconActiveColor: Colors.white,
                  text: 'Home',
                  textColor: Colors.white,
                  backgroundColor: Colors.redAccent.withOpacity(0.9),
                  iconSize: 26,
                  padding: padding,
                ),
                GButton(
                  gap: gap,
                  icon: Icons.bloodtype,
                  iconColor: Colors.white,
                  iconActiveColor: Colors.white,
                  text: 'Blood',
                  textColor: Colors.white,
                  backgroundColor: Colors.redAccent.withOpacity(0.9),
                  iconSize: 26,
                  padding: padding,
                ),
                GButton(
                  gap: gap,
                  icon: Icons.local_hospital_outlined,
                  iconColor: Colors.white,
                  iconActiveColor: Colors.white,
                  text: 'Hospital',
                  textColor: Colors.white,
                  backgroundColor: Colors.redAccent.withOpacity(0.9),
                  iconSize: 26,
                  padding: padding,
                ),
                GButton(
                  gap: gap,
                  icon: Icons.calendar_month_outlined,
                  iconColor: Colors.white,
                  iconActiveColor: Colors.white,
                  text: 'Events',
                  textColor: Colors.white,
                  backgroundColor: Colors.redAccent.withOpacity(0.9),
                  iconSize: 26,
                  padding: padding,
                ),
              ],
              selectedIndex: _index,
              onTabChange: (index) {
                setState(() {
                  _index = index;
                });
                controller.jumpToPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
