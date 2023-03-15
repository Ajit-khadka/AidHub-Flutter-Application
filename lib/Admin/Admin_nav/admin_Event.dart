// ignore_for_file: file_names

import 'package:blood_bank/Admin/Event_page.dart/create_event.dart';
import 'package:flutter/material.dart';

class Adminevent extends StatefulWidget {
  const Adminevent({super.key});

  @override
  State<Adminevent> createState() => _AdmineventState();
}

class _AdmineventState extends State<Adminevent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
          title: const Text(
            'Events',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateEventView()));
          },
          backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
