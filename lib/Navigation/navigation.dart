import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  @override

  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: GNav(
        tabs: [
          GButton(icon: Icons.home),
          GButton(icon: Icons.bloodtype),
          GButton(icon: Icons.local_hospital),
          GButton(icon: Icons.schedule),

        ]
      )

    );
  }
}
