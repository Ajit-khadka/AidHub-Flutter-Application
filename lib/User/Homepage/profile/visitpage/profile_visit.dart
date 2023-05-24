// ignore_for_file: unused_catch_clause, use_build_context_synchronously, unused_field, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../model and utils/model/chat_user.dart';
import '../../../../model and utils/utils/app_color.dart';

class ProfileVisit extends StatefulWidget {
  final ChatUser user;

  const ProfileVisit({super.key, required this.user});

  static const id = 'set_photo_screen';

  @override
  State<ProfileVisit> createState() => _ProfileVisitState();
}

class _ProfileVisitState extends State<ProfileVisit> {
  File? _image;

  String? e;

  File? profileImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
          title: const Text(
            'Profile Visit',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 120,
                        height: 120,
                        margin: const EdgeInsets.only(top: 35),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(70),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(254, 109, 115, 1),
                              Color.fromRGBO(254, 109, 115, 1),
                              Color.fromRGBO(254, 109, 115, 1),
                              Color.fromRGBO(254, 109, 115, 1),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: widget.user.image.isEmpty
                                  ? const CircleAvatar(
                                      radius: 56,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                          'https://cdn1.iconfinder.com/data/icons/user-pictures/100/unknown-512.png'))
                                  : CircleAvatar(
                                      radius: 56,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                        widget.user.image,
                                      )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 0,
                      height: 10,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.user.username,
                    style: const TextStyle(
                        fontSize: 25,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 68, 68, 130)),
                  ),
                  const SizedBox(
                    width: 0,
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                // height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Text(
                  widget.user.status,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 68, 68, 130),
                      fontFamily: 'Poppins'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Personal Information',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color.fromRGBO(254, 109, 115, 1)),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 340,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(254, 109, 115, 1),
                        width: 1.5),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xffDDDDDD),
                        blurRadius: 4.0,
                        spreadRadius: 3.0,
                        offset: Offset(01, 0.0),
                      )
                    ],
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.white),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 68, 68, 130),
                                fontFamily: 'Poppins',
                                height: 3),
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Email :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromRGBO(254, 109, 115, 1),
                                ),
                              ),
                              TextSpan(
                                  text: '\n${widget.user.email}\n',
                                  style: const TextStyle(height: 0)),
                              const TextSpan(
                                text: 'Blood Type :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromRGBO(254, 109, 115, 1),
                                ),
                              ),
                              TextSpan(
                                text: '\n${widget.user.bloodType}\n',
                                style: const TextStyle(height: 0),
                              ),
                              const TextSpan(
                                text: 'Location :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromRGBO(254, 109, 115, 1)),
                              ),
                              TextSpan(
                                text: '\n${widget.user.location}\n',
                                style: const TextStyle(height: 0),
                              ),
                              const TextSpan(
                                text: 'Contact :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromRGBO(254, 109, 115, 1)),
                              ),
                              TextSpan(
                                text: '\n${widget.user.contact}\n',
                                style: const TextStyle(height: 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
