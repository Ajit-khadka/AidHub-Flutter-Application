import 'package:flutter/material.dart';

class BloodRequest extends StatefulWidget {
  const BloodRequest({super.key});

  @override
  State<BloodRequest> createState() => _BloodRequestState();
}

class _BloodRequestState extends State<BloodRequest> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text(
        'Blood Request,',
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 24, fontFamily: 'OpenSans'),
      ),
    );
  }
}
