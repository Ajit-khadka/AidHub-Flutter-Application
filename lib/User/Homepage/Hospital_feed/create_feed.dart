// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_print, non_constant_identifier_names, unused_import, unused_element, unused_local_variable

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:blood_bank/Admin/adminHomePage.dart';
import 'package:blood_bank/User/Homepage/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../model and utils/controller/feed_controller.dart';
import '../../../model and utils/model/feed_model.dart';
import '../../../model and utils/utils/app_color.dart';
import '../../../model and utils/widget/app_widget.dart';

class CreateFeedView extends StatefulWidget {
  const CreateFeedView({Key? key}) : super(key: key);

  @override
  State<CreateFeedView> createState() => _CreateFeedState();
}

class _CreateFeedState extends State<CreateFeedView> {
  DateTime? date = DateTime.now();

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TimeOfDay startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 0, minute: 0);

  // var selectedFrequency = -2;

  void resetControllers() {
    dateController.clear();
    timeController.clear();
    descriptionController.clear();

    setState(() {});
  }

  var isCreatingEvent = false.obs;

  _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    date = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    dateController.text = '${date!.day}-${date!.month}-${date!.year}';
    timeController.text = '${date!.hour}:${date!.minute}:${date!.second}';
    setState(() {});
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> mediaUrls = [];

  List<FeedMediaModel> media = [];

  @override
  void initState() {
    super.initState();
    timeController.text = '${date!.hour}:${date!.minute}:${date!.second}';
    dateController.text = '${date!.day}-${date!.month}-${date!.year}';
  }

  void checkRole() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      var check = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot.get('role') == "Admin") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminHomePage(),
              ),
            );
          } else if (documentSnapshot.get('role') == "User") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          }
        } else {}
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong try again later!");
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
        title: const Text(
          'Create Post',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Select Image",
                      style: TextStyle(
                        color: Color.fromARGB(255, 68, 68, 130),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: Get.width * 0.6,
                    width: Get.width * 0.9,
                    decoration: BoxDecoration(
                        color: AppColors.border.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)),
                    child: DottedBorder(
                      color: AppColors.border,
                      strokeWidth: 1.5,
                      dashPattern: const [6, 6],
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: Get.height * 0.05,
                            ),
                            Container(
                              width: 76,
                              height: 59,
                              child: const Icon(
                                Icons.upload,
                                color: Color.fromARGB(126, 0, 0, 0),
                              ),
                            ),
                            myText(
                              text: 'Click and upload image',
                              style: TextStyle(
                                color: AppColors.blue,
                                fontSize: 19,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            elevatedButton(
                                onpress: () async {
                                  imageDialog(context, true);
                                },
                                text: 'Upload')
                          ],
                        ),
                      ),
                    ),
                  ),
                  media.isEmpty
                      ? Container()
                      : const SizedBox(
                          height: 20,
                        ),
                  media.isEmpty
                      ? Container()
                      : Container(
                          width: Get.width,
                          height: Get.width * 0.3,
                          child: ListView.builder(
                              itemBuilder: (ctx, i) {
                                return media[i].isVideo!
                                    //!isImage[i]
                                    ? Container(
                                        width: Get.width * 0.3,
                                        height: Get.width * 0.3,
                                        margin: const EdgeInsets.only(
                                            right: 15, bottom: 10, top: 10),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: MemoryImage(
                                                  media[i].thumbnail!),
                                              fit: BoxFit.fill),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Stack(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: CircleAvatar(
                                                    child: IconButton(
                                                      onPressed: () {
                                                        media.removeAt(i);
                                                        // media.removeAt(i);
                                                        // isImage.removeAt(i);
                                                        // thumbnail.removeAt(i);
                                                        setState(() {});
                                                      },
                                                      icon: const Icon(
                                                          Icons.close),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Align(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.slow_motion_video_rounded,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    //!isImage[i]

                                    : Container(
                                        width: Get.width * 0.3,
                                        height: Get.width * 0.3,
                                        margin: const EdgeInsets.only(
                                            right: 15, bottom: 10, top: 10),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: FileImage(media[i].image!),
                                              fit: BoxFit.fill),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: CircleAvatar(
                                                child: IconButton(
                                                  onPressed: () {
                                                    media.removeAt(i);
                                                    // isImage.removeAt(i);
                                                    // thumbnail.removeAt(i);
                                                    setState(() {});
                                                  },
                                                  icon: const Icon(Icons.close),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                              },
                              itemCount: media.length,
                              scrollDirection: Axis.horizontal),
                        ),
                  const SizedBox(
                    height: 20,
                  ),

                  Row(
                    children: const [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Post Description",
                          style: TextStyle(
                            color: Color.fromARGB(255, 68, 68, 130),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 149,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          width: 1, color: AppColors.genderTextColor),
                    ),
                    child: TextFormField(
                      maxLines: 5,
                      controller: descriptionController,
                      validator: (input) {
                        if (input!.isEmpty) {
                          Get.snackbar('Opps', "Description is Required.",
                              colorText:
                                  const Color.fromARGB(255, 255, 255, 255),
                              backgroundColor:
                                  const Color.fromRGBO(254, 109, 115, 1));
                          return '';
                        }
                        if (RegExp(r'\s{2,}').hasMatch(input)) {
                          Get.snackbar(
                              'Opps', "Description contains multiple spaces",
                              colorText:
                                  const Color.fromARGB(255, 255, 255, 255),
                              backgroundColor:
                                  const Color.fromRGBO(254, 109, 115, 1));
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.only(top: 25, left: 15, right: 15),
                        hintStyle: TextStyle(
                          color: AppColors.genderTextColor,
                        ),
                        hintText: 'Describe your day...',
                      ),
                    ),
                  ),

                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  Obx(() => isCreatingEvent.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          height: 42,
                          width: double.infinity,
                          child: elevatedButton(
                              onpress: () async {
                                if (!formKey.currentState!.validate()) {
                                  return;
                                }

                                if (media.isEmpty) {
                                  Get.snackbar('Opps', "Photo is Required.",
                                      colorText: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      backgroundColor: const Color.fromRGBO(
                                          254, 109, 115, 1));
                                  return;
                                }

                                isCreatingEvent(true);

                                FeedController dataController = Get.find();

                                if (media.isNotEmpty) {
                                  for (int i = 0; i < media.length; i++) {
                                    if (media[i].isVideo!) {
                                      /// if video then first upload video file and then upload thumbnail and
                                      /// store it in the map
                                      String thumbnailUrl = await dataController
                                          .uploadThumbnailToFirebase(
                                              media[i].thumbnail!);

                                      String videoUrl = await dataController
                                          .uploadImageToFirebase(
                                              media[i].video!);

                                      mediaUrls.add({
                                        'url': videoUrl,
                                        'thumbnail': thumbnailUrl,
                                        'isImage': false
                                      });
                                    } else {
                                      /// just upload image
                                      String imageUrl = await dataController
                                          .uploadImageToFirebase(
                                              media[i].image!);
                                      mediaUrls.add(
                                          {'url': imageUrl, 'isImage': true});
                                    }
                                  }
                                }

                                Map<String, dynamic> eventData = {
                                  'date':
                                      '${date!.day}-${date!.month}-${date!.year}',
                                  'time': '${date!.hour}:${date!.minute}',
                                  'description': descriptionController.text,
                                  'media': mediaUrls,
                                  'uid': FirebaseAuth.instance.currentUser!.uid,
                                };

                                await dataController
                                    .createEvent(eventData)
                                    .then((value) {
                                  Fluttertoast.showToast(
                                      msg: "Post is Uploaded ");
                                  isCreatingEvent(false);
                                  resetControllers();
                                  checkRole();
                                });
                              },
                              text: 'Post'),
                        )),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getImageDialog(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(
      source: source,
    );

    if (image != null) {
      media.add(
          FeedMediaModel(image: File(image.path), video: null, isVideo: false));
    }

    setState(() {});
    Navigator.pop(context);
  }

  void imageDialog(BuildContext context, bool image) {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Media Source"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      if (image) {
                        getImageDialog(ImageSource.gallery);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please try again later ! ");
                      }
                    },
                    icon: const Icon(Icons.image)),
                IconButton(
                    onPressed: () {
                      if (image) {
                        getImageDialog(ImageSource.camera);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please try again later ! ");
                      }
                    },
                    icon: const Icon(Icons.camera_alt)),
              ],
            ),
          );
        },
        context: context);
  }
}
