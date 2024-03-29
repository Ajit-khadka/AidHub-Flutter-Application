// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace, avoid_print, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

// import '../model/ticket_model.dart';

import '../../model and utils/controller/data_controller.dart';
import '../../model and utils/utils/app_color.dart';
import 'event_details.dart';
// import '../views/profile/add_profile.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

Widget EventsFeed() {
  DataController dataController = Get.find<DataController>();

  return Obx(() => dataController.isEventsLoading.value
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, i) {
            return EventItem(dataController.allEvents[i]);
          },
          itemCount: dataController.allEvents.length,
        ));
}

Widget buildCard(
    {String? image, text, Function? func, DocumentSnapshot? eventData}) {
  DataController dataController = Get.find<DataController>();

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
              height: 3,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              child: Row(
                children: [
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
                    width: 15,
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color.fromARGB(255, 68, 68, 130)),
                  ),
                  const Spacer(),
                  InkWell(
                    //
                    onTap: () {
                      deleteSelectedEvent(eventData);
                    },
                    child: Container(
                      width: 22,
                      height: 22,
                      child: Image.asset(
                        'images/delete.png',
                        fit: BoxFit.contain,
                        color: const Color.fromARGB(255, 68, 68, 130),
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
                          margin: const EdgeInsets.only(left: 9),
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
              height: 2,
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

void deleteSelectedEvent(DocumentSnapshot? eventData) async {
  User? user = auth.currentUser;
  try {
    if (user != null) {
      DocumentSnapshot document =
          await firestore.collection('events').doc(eventData!.id).get();
      print(eventData.id);
      String? creatorUid = document.get('uid');
      if (creatorUid == user.uid) {
        print(creatorUid);
        print(user.uid);
        await firestore.collection('events').doc(eventData.id).delete();
        // Show a snackbar or navigate to a new page to confirm deletion
        Fluttertoast.showToast(msg: "Post is Deleted");
      } else {
        Fluttertoast.showToast(msg: "You are not authorized!");
      }
    } else {
      Fluttertoast.showToast(msg: "You are not authorized!");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Check your internet connnection");
    print(e);
  }
}

EventItem(DocumentSnapshot event) {
  DataController dataController = Get.find<DataController>();

  DocumentSnapshot user =
      dataController.allUsers.firstWhere((e) => event.get('uid') == e.id);

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
      SizedBox(
        height: Get.height * 0.01,
      ),
      buildCard(
          image: eventImage,
          text: event.get(
            'event_name',
          ),
          eventData: event,
          func: () {
            Get.to(() => EventPageView(
                  event,
                  user,
                ));
          }),
      const SizedBox(
        height: 15,
      ),
    ],
  );
}

EventsIJoined() {
  DataController dataController = Get.find<DataController>();

  DocumentSnapshot myUser = dataController.allUsers
      .firstWhere((e) => e.id == FirebaseAuth.instance.currentUser!.uid);

  String userImage = '';
  String userName = '';

  try {
    userImage = myUser.get('image');
  } catch (e) {
    userImage = '';
  }

  try {
    userName = '${myUser.get('username')}';
  } catch (e) {
    userName = '';
  }

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
        height: Get.height * 0.015,
      ),
      Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(17)),
          padding: const EdgeInsets.all(10),
          width: 350,
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(userImage),
                    radius: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(254, 109, 115, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Divider(
                height: 15,
                thickness: 1,
                color: const Color(0xff918F8F).withOpacity(0.2),
              ),
              Obx(
                () => dataController.isEventsLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: dataController.joinedEvents.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          String name =
                              dataController.joinedEvents[i].get('event_name');

                          String date =
                              dataController.joinedEvents[i].get('date');

                          date = '${date.split('-')[0]}-${date.split('-')[1]}';

                          List joinedUsers = [];

                          try {
                            joinedUsers =
                                dataController.joinedEvents[i].get('joined');
                          } catch (e) {
                            joinedUsers = [];
                          }

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 41,
                                      height: 24,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                              254, 109, 115, 1),
                                        ),
                                      ),
                                      child: Text(
                                        date,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 68, 68, 130),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  width: Get.width * 0.6,
                                  height: 50,
                                  child: ListView.builder(
                                    itemBuilder: (ctx, index) {
                                      DocumentSnapshot user = dataController
                                          .allUsers
                                          .firstWhere((e) =>
                                              e.id == joinedUsers[index]);

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
                                  )),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}
