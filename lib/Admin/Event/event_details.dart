// ignore_for_file: must_be_immutable, library_private_types_in_public_api, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

// import '../check_out/check_out_screen.dart';
import '../controller/data_controller.dart';
// import '../invite_guest/invite_guest_screen.dart';

import '../utils/app_color.dart';
import 'join_event.dart';

class EventPageView extends StatefulWidget {
  DocumentSnapshot eventData, user;

  EventPageView(this.eventData, this.user, {super.key});

  @override
  _EventPageViewState createState() => _EventPageViewState();
}

class _EventPageViewState extends State<EventPageView> {
  DataController dataController = Get.find<DataController>();

  List eventSavedByUsers = [];

  @override
  Widget build(BuildContext context) {
    String image = '';

    try {
      image = widget.user.get('image');
    } catch (e) {
      image = '';
    }

    String eventImage = '';
    try {
      List media = widget.eventData.get('media') as List;
      Map mediaItem =
          media.firstWhere((element) => element['isImage'] == true) as Map;
      eventImage = mediaItem['url'];
    } catch (e) {
      eventImage = '';
    }

    List joinedUsers = [];

    try {
      joinedUsers = widget.eventData.get('joined');
    } catch (e) {
      joinedUsers = [];
    }

    int likes = 0;
    int comments = 20;

    try {
      likes = widget.eventData.get('likes').length;
    } catch (e) {
      likes = 0;
    }

    try {
      comments = widget.eventData.get('comments').length;
    } catch (e) {
      comments = 0;
    }

    try {
      eventSavedByUsers = widget.eventData.get('saves');
    } catch (e) {
      eventSavedByUsers = [];
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
        title: const Text(
          'Event Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      image,
                    ),
                    radius: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.user.get('username')}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 68, 68, 130)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${widget.user.get('location')}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                        color: const Color(0xffEEEEEE),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Text(
                          '${widget.eventData.get('event')}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: const Color.fromRGBO(254, 109, 115, 1),
                          width: 1.2),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text(
                      '${widget.eventData.get('start_time')}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${widget.eventData.get('event_name')}",
                    style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 68, 68, 130),
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${widget.eventData.get('date')}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Image.asset(
                    'images/location.png',
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${widget.eventData.get('location')}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 190,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(eventImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      width: Get.width * 0.6,
                      height: 50,
                      child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          DocumentSnapshot user = dataController.allUsers
                              .firstWhere((e) => e.id == joinedUsers[index]);

                          String image = '';

                          try {
                            image = user.get('image');
                          } catch (e) {
                            image = '';
                          }

                          return Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: CircleAvatar(
                              minRadius: 13,
                              backgroundImage: NetworkImage(image),
                            ),
                          );
                        },
                        itemCount: joinedUsers.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${widget.eventData.get('max_entries')} spots left!",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: widget.eventData.get('description'),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ])),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.off(() => CheckOutView(widget.eventData));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(254, 109, 115, 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 0.1,
                                blurRadius: 60,
                                offset: const Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(13)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: const Center(
                          child: Text(
                            'Join Event ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
