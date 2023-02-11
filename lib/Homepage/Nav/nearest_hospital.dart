import 'package:flutter/material.dart';

class NearestHospital extends StatefulWidget {
  const NearestHospital({super.key});

  @override
  State<NearestHospital> createState() => _NearestHospitalState();
}

class _NearestHospitalState extends State<NearestHospital> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Nearest Hospital,',
          style: TextStyle(fontSize: 24, fontFamily: 'OpenSans'),
        ),
      ),
    );
  }
}
