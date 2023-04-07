// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace, avoid_print

import 'package:blood_bank/Admin/controller/feed_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../views/profile/add_profile.dart';

Widget UserPostFeed() {
  FeedController feedController = Get.find<FeedController>();

  return Obx(() => feedController.isEventsLoading.value
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, i) {
            return UserPostItem(feedController.allEvents[i]);
          },
          itemCount: feedController.allEvents.length,
        ));
}

Widget buildCard(
    {String? image, text, Function? func, DocumentSnapshot? eventData}) {
  FeedController feedController = Get.find<FeedController>();

  List joinedUsers = [];

  try {
    joinedUsers = eventData!.get('joined');
  } catch (e) {
    joinedUsers = [];
  }

  List dateInformation = [];
  try {
    dateInformation = eventData!.get('date').toString().split('-');
  } catch (e) {
    dateInformation = [];
  }

  List timeInformation = [];
  try {
    timeInformation = eventData!.get('time').toString().split('-');
  } catch (e) {
    timeInformation = [];
  }

  int comments = 0;

  List userLikes = [];

  try {
    userLikes = eventData!.get('likes');
  } catch (e) {
    userLikes = [];
  }

  try {
    comments = eventData!.get('comments').length;
  } catch (e) {
    comments = 0;
  }

  List eventSavedByUsers = [];
  try {
    eventSavedByUsers = eventData!.get('saves');
  } catch (e) {
    eventSavedByUsers = [];
  }

  return SingleChildScrollView(
    child: Material(
      // elevation: 2,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Container(
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0x000602d3).withOpacity(0.15),
              spreadRadius: 0.1,
              blurRadius: 2,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        width: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                func!();
              },
              child: Container(
                // child: Image.network(image!,fit: BoxFit.fill,),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(image!), fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(15),
                ),

                width: double.infinity,
                height: Get.width * 0.5,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              height: 3,
              thickness: 1,
              color: const Color(0xff918F8F).withOpacity(0.2),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Row(
                children: [
                  const Text(
                    'Date - ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 68, 68, 130),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 41,
                    height: 24,
                    // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: const Color.fromRGBO(254, 109, 115, 1))),
                    child: Text(
                      '${dateInformation[0]}-${dateInformation[1]}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 68, 68, 130),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Time - ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 68, 68, 130),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 50,
                    height: 24,
                    // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: const Color.fromRGBO(254, 109, 115, 1))),
                    child: Text(
                      '${timeInformation[0]}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 68, 68, 130),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Spacer(),
                  InkWell(
                    //
                    onTap: () {
                      if (eventSavedByUsers
                          .contains(FirebaseAuth.instance.currentUser!.uid)) {
                        FirebaseFirestore.instance
                            .collection('feeds')
                            .doc(eventData!.id)
                            .set({
                          'saves': FieldValue.arrayRemove(
                              [FirebaseAuth.instance.currentUser!.uid])
                        }, SetOptions(merge: true));
                      } else {
                        FirebaseFirestore.instance
                            .collection('feeds')
                            .doc(eventData!.id)
                            .set({
                          'saves': FieldValue.arrayUnion(
                              [FirebaseAuth.instance.currentUser!.uid])
                        }, SetOptions(merge: true));
                      }
                    },
                    child: Container(
                      width: 16,
                      height: 19,
                      child: Image.asset(
                        'images/boomMark.png',
                        fit: BoxFit.contain,
                        color: eventSavedByUsers.contains(
                                FirebaseAuth.instance.currentUser!.uid)
                            ? const Color.fromRGBO(254, 109, 115, 1)
                            : const Color.fromARGB(255, 68, 68, 130),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                    width: Get.width * 0.5,
                    height: 8,
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        DocumentSnapshot user = feedController.allUsers
                            .firstWhere((e) => e.id == joinedUsers[index]);

                        String image = '';

                        try {
                          image = user.get('image');
                        } catch (e) {
                          image = '';
                        }

                        return Container(
                          margin: const EdgeInsets.only(left: 60),
                          child: CircleAvatar(
                            minRadius: 15,
                            backgroundImage: NetworkImage(image),
                          ),
                        );
                      },
                      itemCount: joinedUsers.length,
                      scrollDirection: Axis.horizontal,
                    )),
              ],
            ),
            const SizedBox(
              height: 0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                softWrap: true,
                style: const TextStyle(
                    fontSize: 15, color: Color.fromARGB(255, 68, 68, 130)),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 0,
                ),
                InkWell(
                  onTap: () {
                    if (userLikes
                        .contains(FirebaseAuth.instance.currentUser!.uid)) {
                      try {
                        FirebaseFirestore.instance
                            .collection('feeds')
                            .doc(eventData!.id)
                            .set({
                          'likes': FieldValue.arrayRemove(
                              [FirebaseAuth.instance.currentUser!.uid]),
                        }, SetOptions(merge: true));
                      } catch (e) {
                        debugPrint(FirebaseAuth.instance.currentUser!.uid);
                        print(e);
                      }
                    } else {
                      try {
                        FirebaseFirestore.instance
                            .collection('feeds')
                            .doc(eventData!.id)
                            .set({
                          'likes': FieldValue.arrayUnion(
                              [FirebaseAuth.instance.currentUser!.uid]),
                        }, SetOptions(merge: true));
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 25,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.favorite,
                      size: 20,
                      color: userLikes
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? const Color.fromRGBO(254, 109, 115, 1)
                          : const Color.fromARGB(255, 68, 68, 130),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '${userLikes.length}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 68, 68, 130),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  width: 17,
                  height: 19,
                  child: Image.asset(
                    'images/message.png',
                    color: const Color.fromARGB(255, 68, 68, 130),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '$comments',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 68, 68, 130),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  width: 17,
                  height: 30,
                  child: Image.asset(
                    'images/send.png',
                    fit: BoxFit.contain,
                    color: const Color.fromARGB(255, 68, 68, 130),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 3,
            ),
          ],
        ),
      ),
    ),
  );
}

UserPostItem(DocumentSnapshot event) {
  FeedController feedController = Get.find<FeedController>();

  DocumentSnapshot user =
      feedController.allUsers.firstWhere((e) => event.get('uid') == e.id);

  String image = '';

  try {
    image = user.get('image');
  } catch (e) {
    image = '';
  }

  String eventImage = '';
  try {
    List media = event.get('media') as List;
    Map mediaItem =
        media.firstWhere((element) => element['isImage'] == true) as Map;
    eventImage = mediaItem['url'];
  } catch (e) {
    eventImage = '';
  }

  return Column(
    children: [
      Row(
        children: [
          const SizedBox(
            width: 12,
            height: 60,
          ),
          InkWell(
            onTap: () {
              // Get.to(() => ProfileScreen());
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(image),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            '${user.get('username')}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 68, 68, 130),
            ),
          ),
        ],
      ),
      SizedBox(
        height: Get.height * 0.01,
      ),
      buildCard(
          image: eventImage,
          text: event.get(
            'description',
          ),
          eventData: event,
          func: () {
            // Get.to(() => EventPageView(
            //       event,
            //       user,
            //     ));
          }),
      const SizedBox(
        height: 15,
      ),
    ],
  );
}

UserPostMade() {
  // FeedController feedController = Get.find<FeedController>();
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: const Icon(
              Icons.stop_circle_outlined,
              color: Color.fromRGBO(254, 109, 115, 1),
            ),
          ),
          const SizedBox(
            width: 0,
          ),
          const Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 68, 68, 130),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      SizedBox(
        height: Get.height * 0.016,
      ),
    ],
  );
}
