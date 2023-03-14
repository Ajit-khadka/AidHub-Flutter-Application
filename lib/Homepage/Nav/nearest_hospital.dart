import 'package:flutter/material.dart';

class NearestHospital extends StatefulWidget {
  const NearestHospital({super.key});

  @override
  State<NearestHospital> createState() => _NearestHospitalState();
}

class _NearestHospitalState extends State<NearestHospital> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
        title: const Text(
          'Nearest Hospital',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          'Nearest Hospital,',
          style: TextStyle(fontSize: 24, fontFamily: 'OpenSans'),
        ),
      ),
    );
  }
}
