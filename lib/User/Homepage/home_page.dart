// ignore_for_file: use_build_context_synchronously, avoid_unnecessary_containers, file_names

import 'package:blood_bank/User/Homepage/Nav/nearest_hospital.dart';
import 'package:blood_bank/User/Homepage/Nav/par_event.dart';
import 'package:blood_bank/User/Homepage/Nav/profile_screen.dart';
import 'package:blood_bank/User/Homepage/Nav/hospital_feed.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../model and utils/controller/data_controller.dart';
import '../../model and utils/controller/feed_controller.dart';

import 'Message/messagehome.dart';

//navigation bar
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

var styleList = const TextStyle(color: Colors.black, fontSize: 24);

class _HomePageState extends State<HomePage> {
  // User? user = FirebaseAuth.instance.currentUser;
  // UserModel loggedInUser = UserModel();

  var padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 200);
  double gap = 10;
  int _index = 0;

  List<Widget> widgetsList = const [
    HospitalFeed(),
    MessageHomeScreen(),
    NearestHospital(),
    Events(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Get.put(DataController(), permanent: true);
    Get.put(FeedController(), permanent: true);
  }

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // This will prevent the user from navigating back
      },
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          body: PageView.builder(
              itemCount: 5,
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
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(254, 109, 115, 1),
                  borderRadius: const BorderRadius.all(Radius.circular(0)),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: -10,
                      blurRadius: 60,
                      color: Colors.black.withOpacity(0.4),
                      offset: const Offset(0, 25),
                    )
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                child: GNav(
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 500),
                  tabs: [
                    //tab UI
                    GButton(
                      gap: gap,
                      icon: Icons.home,
                      iconColor: Colors.white,
                      iconActiveColor: Colors.white,
                      text: 'Home',
                      textColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 255, 63, 63)
                          .withOpacity(0.9),
                      iconSize: 26,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                    ),
                    GButton(
                      gap: gap,
                      icon: Icons.bloodtype,
                      iconColor: Colors.white,
                      iconActiveColor: Colors.white,
                      text: 'Blood',
                      textColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 255, 63, 63)
                          .withOpacity(0.9),
                      iconSize: 26,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                    ),
                    GButton(
                      gap: gap,
                      icon: Icons.local_hospital_outlined,
                      iconColor: Colors.white,
                      iconActiveColor: Colors.white,
                      text: 'Hospital',
                      textColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 255, 63, 63)
                          .withOpacity(0.9),
                      iconSize: 26,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                    ),
                    GButton(
                      gap: gap,
                      icon: Icons.calendar_month_outlined,
                      iconColor: Colors.white,
                      iconActiveColor: Colors.white,
                      text: 'Events',
                      textColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 255, 63, 63)
                          .withOpacity(0.9),
                      iconSize: 26,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                    ),
                    GButton(
                      gap: gap,
                      icon: LineAwesomeIcons.user,
                      iconColor: Colors.white,
                      iconActiveColor: Colors.white,
                      text: 'Profile',
                      textColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 255, 63, 63)
                          .withOpacity(0.9),
                      iconSize: 26,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
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
        ),
      ),
    );
  }
}
