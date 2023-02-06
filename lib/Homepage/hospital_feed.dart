import 'package:flutter/material.dart';

class HospitalFeed extends StatefulWidget {
  const HospitalFeed({super.key});

  @override
  State<HospitalFeed> createState() => _HospitalFeedState();
}

class _HospitalFeedState extends State<HospitalFeed> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Text(
        'Hello,',
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 24, fontFamily: 'OpenSans'),
      ),
    );
  }
}
