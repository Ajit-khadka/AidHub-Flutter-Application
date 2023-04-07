// ignore_for_file: must_be_immutable, avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../widget/app_widget.dart';

class CheckOutView extends StatefulWidget {
  DocumentSnapshot? eventDoc;

  CheckOutView(this.eventDoc, {super.key});

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
        title: const Text(
          'Event Rules',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            // height: Get.height,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(children: [
              const SizedBox(
                height: 0,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Rules to know before coming to event :",
                  style: TextStyle(
                    color: Color.fromARGB(255, 68, 68, 130),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "1. Bring blood grouping card.\n2. Bring Citizenship card. \n3. Follow Time schedule of hospital.\n4. Avoid Patient ward during event.",
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16,
                    wordSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 50,
                width: double.infinity,
                child: elevatedButton(
                  onpress: () {
                    joinUser(context, eventId: widget.eventDoc!.id);
                  },
                  text: 'Join Event',
                ),
              ),
            ])),
      ),
    );
  }
}

Future<void> joinUser(BuildContext context, {String? eventId}) async {
  try {
    await FirebaseFirestore.instance.collection('events').doc(eventId).set({
      'joined': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      'max_entries': FieldValue.increment(-1),
    }, SetOptions(merge: true)).then((value) {
      FirebaseFirestore.instance.collection('booking').doc(eventId).set({
        'booking': FieldValue.arrayUnion([
          {'uid': FirebaseAuth.instance.currentUser!.uid, 'tickets': 1}
        ])
      }).then((value) {
        Timer(const Duration(seconds: 1), () {
          Fluttertoast.showToast(msg: "You joined the Event");
          Get.back();
        });
      });
    });
  } catch (e) {
    Fluttertoast.showToast(msg: "Check your internet connection!");
    print(e);
  }
}
