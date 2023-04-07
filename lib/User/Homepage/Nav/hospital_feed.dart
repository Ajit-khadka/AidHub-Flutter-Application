// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Admin/controller/data_controller.dart';
import '../../../Admin/controller/feed_controller.dart';
import '../../../Admin/utils/app_color.dart';
import '../Hospital_feed/create_feed.dart';
import '../Hospital_feed/user_show_feed.dart';

class HospitalFeed extends StatefulWidget {
  const HospitalFeed({super.key});

  @override
  State<HospitalFeed> createState() => _HospitalFeedState();
}

class _HospitalFeedState extends State<HospitalFeed> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String name = '...';
  String uid = '';

  @override
  void initState() {
    super.initState();
    getData();
    UserPostFeed();
  }

  FeedController feedController = Get.find<FeedController>();
  DataController dataController = Get.find<DataController>();

  Future<void> getData() async {
    User? user = _auth.currentUser;
    uid = user!.uid;
    // debugPrint("user.uid $uid");
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (mounted) {
      setState(() {
        name = userDoc.get('username');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(245, 243, 241, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
          title: const Text(
            'Hospital Feed',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateFeedView()));
          },
          backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(children: [
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    text: '  Hello,\n',
                    style: const TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 68, 68, 130),
                        fontFamily: 'Poppins'),
                    children: <TextSpan>[
                      TextSpan(
                          text: '  $name !',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
              Obx(() => dataController.isUsersLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : UserEventsIJoined()),
              const SizedBox(
                height: 6,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "    Posts created by community !",
                  style: TextStyle(
                    color: Color.fromARGB(255, 68, 68, 130),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              UserPostFeed(),
              UserPostMade(),
            ]),
          ),
        ),
      ),
    );
  }
}

UserEventsIJoined() {
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
          height: 230,
          child: ListView(children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                " Joined Event",
                style: TextStyle(
                  color: Color.fromRGBO(254, 109, 115, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                ),
              ),
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
                                    width: 41, height: 24,
                                    alignment: Alignment.center,
                                    // padding: EdgeInsets.symmetric(
                                    //     horizontal: 10, vertical: 7),
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
                                    DocumentSnapshot user =
                                        dataController.allUsers.firstWhere(
                                            (e) => e.id == joinedUsers[index]);

                                    String image = '';

                                    try {
                                      image = user.get('image');
                                    } catch (e) {
                                      image = '';
                                    }

                                    return Container(
                                      margin: const EdgeInsets.only(left: 15),
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
          ]),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
    ],
  );
}
