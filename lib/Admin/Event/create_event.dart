// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_print, non_constant_identifier_names, unused_import

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:blood_bank/Admin/adminHomePage.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../model/event_model.dart';
import '../controller/data_controller.dart';
import '../utils/app_color.dart';
import '../widget/app_widget.dart';

class CreateEventView extends StatefulWidget {
  const CreateEventView({Key? key}) : super(key: key);

  @override
  State<CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  DateTime? date = DateTime.now();

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController maxEntries = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TimeOfDay startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 0, minute: 0);

  var selectedFrequency = -2;

  void resetControllers() {
    dateController.clear();
    timeController.clear();
    titleController.clear();
    locationController.clear();
    descriptionController.clear();
    maxEntries.clear();
    endTimeController.clear();
    startTimeController.clear();

    startTime = const TimeOfDay(hour: 0, minute: 0);
    endTime = const TimeOfDay(hour: 0, minute: 0);
    setState(() {});
  }

  var isCreatingEvent = false.obs;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      date = DateTime(picked.year, picked.month, picked.day, date!.hour,
          date!.minute, date!.second);
      dateController.text = '${date!.day}-${date!.month}-${date!.year}';
    }
    setState(() {});
  }

  startTimeMethod(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      startTime = picked;
      startTimeController.text =
          '${startTime.hourOfPeriod > 9 ? "" : '0'}${startTime.hour > 12 ? '${startTime.hour - 12}' : startTime.hour}:${startTime.minute > 9 ? startTime.minute : '0${startTime.minute}'} ${startTime.hour > 12 ? 'PM' : 'AM'}';
    }
    debugPrint("start ${startTimeController.text}");
    setState(() {});
  }

  endTimeMethod(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      endTime = picked;
      endTimeController.text =
          '${endTime.hourOfPeriod > 9 ? "" : "0"}${endTime.hour > 9 ? "" : "0"}${endTime.hour > 12 ? '${endTime.hour - 12}' : endTime.hour}:${endTime.minute > 9 ? endTime.minute : '0${endTime.minute}'} ${endTime.hour > 12 ? 'PM' : 'AM'}';
    }

    print(endTime.hourOfPeriod);
    setState(() {});
  }

  String event_type = 'Public';
  List<String> list_item = ['Public', 'Private'];

  String accessModifier = 'Closed';
  List<String> close_list = [
    'Closed',
    'Open',
  ];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> mediaUrls = [];

  List<EventMediaModel> media = [];

  // List<File> media = [];
  // List thumbnail = [];
  // List<bool> isImage = [];

  @override
  void initState() {
   
    super.initState();
    timeController.text = '${date!.hour}:${date!.minute}:${date!.second}';
    dateController.text = '${date!.day}-${date!.month}-${date!.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
        title: const Text(
          'Create Event',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      width: 90,
                      height: 33,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.black.withOpacity(0.6),
                                  width: 0.6))),
                      child: DropdownButton(
                        isExpanded: true,
                        underline: Container(
                            // decoration: BoxDecoration(
                            //   border: Border.all(
                            //     width: 0,
                            //     color: Colors.white,
                            //   ),
                            // ),
                            ),

                        // borderRadius: BorderRadius.circular(10),
                        icon: const Icon(
                          LineAwesomeIcons.angle_down,
                          size: 10,
                        ),
                        elevation: 16,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                        value: event_type,
                        onChanged: (String? newValue) {
                          setState(
                            () {
                              event_type = newValue!;
                            },
                          );
                        },
                        items: list_item
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
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
                                        borderRadius: BorderRadius.circular(10),
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
                                                    icon:
                                                        const Icon(Icons.close),
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
                                        borderRadius: BorderRadius.circular(10),
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
                myTextField(
                    bool: false,
                    icon: const Icon(Icons.edit_calendar_outlined),
                    text: 'Event Name',
                    controller: titleController,
                    validator: (String input) {
                      if (input.isEmpty) {
                        Get.snackbar('Opps', "Event name is Required.",
                            colorText: const Color.fromARGB(255, 68, 68, 130),
                            backgroundColor:
                                const Color.fromRGBO(254, 109, 115, 1));

                        return '';
                      }

                      if (input.length < 3) {
                        Get.snackbar('Opps', "Event name is Invalid.",
                            colorText: const Color.fromARGB(255, 68, 68, 130),
                            backgroundColor:
                                const Color.fromRGBO(254, 109, 115, 1));
                        return '';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 20,
                ),
                myTextField(
                    bool: false,
                    icon: const Icon(LineAwesomeIcons.search_location),
                    text: 'Location',
                    controller: locationController,
                    validator: (String input) {
                      if (input.isEmpty) {
                        Get.snackbar('Opps', "Location is Required.",
                            colorText: const Color.fromARGB(255, 68, 68, 130),
                            backgroundColor:
                                const Color.fromRGBO(254, 109, 115, 1));
                        return '';
                      }

                      if (input.length < 3) {
                        Get.snackbar('Opps', "Location is Invalid",
                            colorText: const Color.fromARGB(255, 68, 68, 130),
                            backgroundColor:
                                const Color.fromRGBO(254, 109, 115, 1));

                        return '';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    iconTitleContainer(
                      isReadOnly: true,
                      path: const Icon(Icons.date_range),
                      text: 'Date',
                      controller: dateController,
                      validator: (input) {
                        if (date == null) {
                          Get.snackbar('Opps', "Date is Required.",
                              colorText: const Color.fromARGB(255, 68, 68, 130),
                              backgroundColor:
                                  const Color.fromRGBO(254, 109, 115, 1));
                          return '';
                        }
                        return null;
                      },
                      onPress: () {
                        _selectDate(context);
                      },
                    ),
                    iconTitleContainer(
                        path: const Icon(Icons.people),
                        text: 'Max Entries',
                        controller: maxEntries,
                        type: TextInputType.number,
                        onPress: () {},
                        validator: (String input) {
                          if (input.isEmpty) {
                            Get.snackbar('Opps', "Entries is Required.",
                                colorText: Colors.white,
                                backgroundColor:
                                    const Color.fromRGBO(254, 109, 115, 1));
                            return '';
                          }
                          return null;
                        }),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    iconTitleContainer(
                        path: const Icon(LineAwesomeIcons.clock),
                        text: 'Start Time',
                        controller: startTimeController,
                        isReadOnly: true,
                        validator: (input) {},
                        onPress: () {
                          startTimeMethod(context);
                        }),
                    iconTitleContainer(
                        path: const Icon(LineAwesomeIcons.clock),
                        text: 'End Time',
                        isReadOnly: true,
                        controller: endTimeController,
                        validator: (input) {},
                        onPress: () {
                          endTimeMethod(context);
                        }),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: const [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "About Event",
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
                    border:
                        Border.all(width: 1, color: AppColors.genderTextColor),
                  ),
                  child: TextFormField(
                    maxLines: 5,
                    controller: descriptionController,
                    validator: (input) {
                      if (input!.isEmpty) {
                        Get.snackbar('Opps', "Description is Required.",
                            colorText: const Color.fromARGB(255, 68, 68, 130),
                            backgroundColor:
                                const Color.fromRGBO(254, 109, 115, 1));
                        return '';
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
                      hintText:
                          'Describe people should know about the event...',
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(8.0),
                      // ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Event Status",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            width: 1, color: AppColors.genderTextColor),
                      ),
                      // decoration: BoxDecoration(
                      //
                      //   // borderRadius: BorderRadius.circular(8),
                      //    border: Border(
                      //         bottom: BorderSide(color: Colors.black.withOpacity(0.8),width: 0.6)
                      //     )
                      //
                      // ),
                      child: DropdownButton(
                        isExpanded: true,
                        underline: Container(),
                        //borderRadius: BorderRadius.circular(10),
                        icon: const Icon(Icons.time_to_leave),
                        elevation: 16,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                        value: accessModifier,
                        onChanged: (String? newValue) {
                          setState(
                            () {
                              accessModifier = newValue!;
                            },
                          );
                        },
                        items: close_list
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffA6A6A6),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
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
                                    colorText:
                                        const Color.fromARGB(255, 68, 68, 130),
                                    backgroundColor:
                                        const Color.fromRGBO(254, 109, 115, 1));

                                return;
                              }

                              isCreatingEvent(true);

                              DataController dataController = Get.find();

                              if (media.isNotEmpty) {
                                for (int i = 0; i < media.length; i++) {
                                  if (media[i].isVideo!) {
                                    /// if video then first upload video file and then upload thumbnail and
                                    /// store it in the map
                                    String thumbnailUrl = await dataController
                                        .uploadThumbnailToFirebase(
                                            media[i].thumbnail!);

                                    String videoUrl = await dataController
                                        .uploadImageToFirebase(media[i].video!);

                                    mediaUrls.add({
                                      'url': videoUrl,
                                      'thumbnail': thumbnailUrl,
                                      'isImage': false
                                    });
                                  } else {
                                    /// just upload image
                                    String imageUrl = await dataController
                                        .uploadImageToFirebase(media[i].image!);
                                    mediaUrls.add(
                                        {'url': imageUrl, 'isImage': true});
                                  }
                                }
                              }

                              Map<String, dynamic> eventData = {
                                'event': event_type,
                                'event_name': titleController.text,
                                'location': locationController.text,
                                'date':
                                    '${date!.day}-${date!.month}-${date!.year}',
                                'start_time': startTimeController.text,
                                'end_time': endTimeController.text,
                                'max_entries': int.parse(maxEntries.text),
                                'description': descriptionController.text,
                                'who_can_invite': accessModifier,
                                'joined': [
                                  FirebaseAuth.instance.currentUser!.uid
                                ],
                                'media': mediaUrls,
                                'uid': FirebaseAuth.instance.currentUser!.uid,
                                'inviter': [
                                  FirebaseAuth.instance.currentUser!.uid
                                ]
                              };

                              await dataController
                                  .createEvent(eventData)
                                  .then((value) {
                                Fluttertoast.showToast(
                                    msg: "Event is Created ");
                                isCreatingEvent(false);
                                resetControllers();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const AdminHomePage()));
                              });
                            },
                            text: 'Create Event'),
                      )),
                SizedBox(
                  height: Get.height * 0.03,
                ),
              ],
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
      media.add(EventMediaModel(
          image: File(image.path), video: null, isVideo: false));
    }

    setState(() {});
    Navigator.pop(context);
  }

  getVideoDialog(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? video = await _picker.pickVideo(
      source: source,
    );

    if (video != null) {
      // media.add(File(image.path));

      Uint8List? uint8list = await VideoThumbnail.thumbnailData(
        video: video.path,
        imageFormat: ImageFormat.JPEG,
        quality: 75,
      );

      media.add(EventMediaModel(
          thumbnail: uint8list!, video: File(video.path), isVideo: true));
      // thumbnail.add(uint8list!);
      //
      // isImage.add(false);
    }

    // print(thumbnail.first.path);
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
                        getVideoDialog(ImageSource.gallery);
                      }
                    },
                    icon: const Icon(Icons.image)),
                IconButton(
                    onPressed: () {
                      if (image) {
                        getImageDialog(ImageSource.camera);
                      } else {
                        getVideoDialog(ImageSource.camera);
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
