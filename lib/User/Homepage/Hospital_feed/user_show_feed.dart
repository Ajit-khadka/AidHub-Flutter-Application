// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../model and utils/controller/feed_controller.dart';
import '../../../model and utils/model/chat_user.dart';

// import '../views/profile/add_profile.dart';

late final ChatUser user;
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
// String selectedPhotoPath;

// void deleteDocument(String id) async {
//   User? user = auth.currentUser;
//   if (user != null) {
//     DocumentSnapshot document =
//         await firestore.collection('feeds').doc(id).get();
//     print(id);
//     String? creatorUid = document.get('uid');
//     if (creatorUid == user.uid) {
//       print(creatorUid);
//       print(user.uid);
//       await firestore.collection('feeds').doc(id).delete();
//       // Show a snackbar or navigate to a new page to confirm deletion
//       Fluttertoast.showToast(msg: "Post is Deleted");
//     } else {
//       Fluttertoast.showToast(msg: "You are not authorized!");
//     }
//   } else {
//     // Show a login page or redirect the user to log in before allowing document deletion
//   }
// }

void deleteSelectedPhoto() async {
  User? user = auth.currentUser;
  if (user != null) {
    QuerySnapshot querySnapshot = await firestore
        .collection('feeds')
        .where('uid', isEqualTo: user.uid)
        .get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    if (documents.isNotEmpty) {
      await documents.first.reference.delete();
      // Show a snackbar or navigate to a new page to confirm deletion
      Fluttertoast.showToast(msg: "Photo is Deleted");
    } else {
      Fluttertoast.showToast(msg: "Photo not found!");
    }
  } else {
    // Show a login page or redirect the user to log in before allowing document deletion
  }
}

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
                    // Delete selected photo
                    onTap: () async {
                      deleteSelectedPhoto();
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
                  // InkWell(
                  //   //delete data
                  //   onTap: () async {
                  //     String uid = '';
                  //     final FirebaseAuth auth = FirebaseAuth.instance;
                  //     User? user = auth.currentUser;
                  //     uid = user!.uid;
                  //     debugPrint("user.uid $uid");

                  //     final QuerySnapshot querySnapshot = await firestore
                  //         .collection('feeds')
                  //         .where('uid',
                  //             isEqualTo: uid) // get documents with matching UID
                  //         .limit(
                  //             1) // limit the query to only return one document
                  //         .get();
                  //     final List<DocumentSnapshot> documents =
                  //         querySnapshot.docs;
                  //     if (documents.isNotEmpty) {
                  //       await documents.first.reference
                  //           .delete(); // delete the first (and only) document
                  //     }
                  //   },
                  //   child: Container(
                  //     width: 22,
                  //     height: 22,
                  //     child: Image.asset(
                  //       'images/delete.png',
                  //       fit: BoxFit.contain,
                  //       color: const Color.fromARGB(255, 68, 68, 130),
                  //     ),
                  //   ),
                  // ),
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
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    width: 17,
                    height: 19,
                    child: Image.asset(
                      'images/message.png',
                      color: const Color.fromARGB(255, 68, 68, 130),
                    ),
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
              // // UserPostItemmo(event);
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

// Define a function to delete a photo given its file path
Future<void> deletePhoto(String filePath) async {
  final QuerySnapshot querySnapshot = await firestore
      .collection('feeds')
      .where('url',
          isEqualTo: filePath) // get documents with matching photo path
      .get();
  final List<DocumentSnapshot> documents = querySnapshot.docs;
  if (documents.isNotEmpty) {
    await documents.first.reference
        .delete(); // delete the first (and only) document
  }
}




// void deleteButton(BuildContext context) async {
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: false, // user must tap button!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text(
//           'Delete Feed',
//           style: TextStyle(
//             color: Color.fromARGB(255, 68, 68, 130),
//             fontSize: 20,
//             fontFamily: 'OpenSans',
//             fontWeight: FontWeight.bold,
//             letterSpacing: 0,
//           ),
//         ),
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: const <Widget>[
//               Text('Do want to delete this feed?'),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('Yes'),
//             onPressed: () {},
//           ),
//           TextButton(
//             child: const Text('No'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }


// final CollectionReference collectionRef =
//                           FirebaseFirestore.instance.collection('feeds');

//                       final QuerySnapshot querySnapshot = await collectionRef
//                           .where('uid', isEqualTo: uid)
//                           .get();

//                       querySnapshot.docs.forEach((doc) async {
//                         await doc.reference.delete();


                      // final CollectionReference collectionRef =
                      //     FirebaseFirestore.instance.collection('feeds');

                      // final QuerySnapshot querySnapshot = await collectionRef
                      //     .where('uid', isEqualTo: user.uid)
                      //     .limit(1)
                      //     .get();

                      // print(querySnapshot);

                      // querySnapshot.docs.forEach((documentSnapshot) async {
                      //   final DocumentReference documentRef =
                      //       documentSnapshot.reference;

                      //   await documentRef.delete();
                      // });

                      // final DocumentSnapshot userDoc = await FirebaseFirestore
                      //     .instance
                      //     .collection('feeds')
                      //     .doc(uid)
                      //     .get();
                      // print(collectionRef);

                      // try {
                      //   if (uid == userDoc) {
                      //     FirebaseFirestore.instance
                      //         .collection('feeds')
                      //         .doc(eventData!.id)
                      //         .delete();
                      //   } else {
                      //     print("error");
                      //   }
                      // } catch (e) {
                      //   print(e);
                      // }