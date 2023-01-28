// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../loginPage/login.dart';
import '../user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

var styleList = const TextStyle(color: Colors.white,
    fontSize: 24
);

class _HomePageState extends State<HomePage> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  var padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 20);
  double gap = 10;

  int _index = 0;
  List<Color> colors = [
    Colors.white,
    Colors.pink,
    Colors.orange,
    Colors.red
  ];

  List<Text> text = [
    const Text('Hello,',
      textAlign: TextAlign.right,
      style: TextStyle(
          fontSize: 24,
        fontFamily: 'OpenSans'
    ),

    ),

    Text('Create Request', style: styleList,),
    Text('Nearest hospital', style: styleList,),
    Text('Events', style: styleList,),
  ];
  PageController controller = PageController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed:(){
                logout(context);
              },
              icon: const Icon(Icons.logout),
            )
          ],
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
                color: colors[position],
                child: Center(child: text[position]),
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
                ]
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              child: GNav(
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 500),
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

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}
