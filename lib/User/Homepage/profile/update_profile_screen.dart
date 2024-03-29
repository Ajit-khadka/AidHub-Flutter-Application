// ignore_for_file: prefer_const_constructors, library_prefixes, depend_on_referenced_packages, unused_import, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import '../../../model and utils/model/user_model.dart';
import '../../../model and utils/utils/app_color.dart';
import '../home_page.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var usernameController = TextEditingController();
  var bloodController = TextEditingController();
  var contactController = TextEditingController();
  var statusController = TextEditingController();
  var locationController = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String? requiredPass(value) {
    if (value.length < 6) {
      return "Minimum 6 digit";
    } else if (value.length > 10) {
      return "Maximum 10 digit";
    } else {
      return null;
    }
  }

  String? wordLimit(value) {
    if (value!.isEmpty) {
      return "Required";
    } else if (value.length > 30) {
      return "Maximum 30 digit";
    } else {
      return null;
    }
  }

  String? featureLen(value) {
    if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
      return "Not a valid Feature";
    } else if (RegExp(r'\s{2,}').hasMatch(value)) {
      return "Contains multiple spaces";
    } else if (value.length < 6) {
      return "Minimum 6 letter";
    } else if (value.length > 20) {
      return "Maximum 20 letter";
    } else {
      return null;
    }
  }

  String? privateNumber(value) {
    if (value!.isEmpty) {
      return "Required";
    } else if (value.length > 10) {
      return "Maximum 10 digit";
    } else {
      return null;
    }
  }

  var myUser = UserModel();

  String name = '...';
  String uid = '';
  String bloodType = '...';
  String email = "...";
  String contact = "...";
  String password = "...";
  String status = "...";
  String location = "...";
  String image = '';
  String imageUrl = '';
  String cloudimage = '';

  Future getUserInfo() async {
    User? user = _auth.currentUser;
    uid = user!.uid;
    try {
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        name = userDoc.get('username');
        bloodType = userDoc.get('bloodType');
        email = userDoc.get('email');
        contact = userDoc.get('contact');
        status = userDoc.get("status");
        location = userDoc.get("location");
        // cloudimage = userDoc.get("image");
        // debugPrint(name);
      });
      usernameController = TextEditingController(text: name);
      bloodController = TextEditingController(text: bloodType);
      contactController = TextEditingController(text: contact);
      locationController = TextEditingController(text: location);
      statusController = TextEditingController(text: status);
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong try again later!");
      // print(e);
    }
  }

  void updateData() async {
    User? user = _auth.currentUser;
    uid = user!.uid;
    try {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'username': usernameController.text.trim(),
        'bloodType': bloodController.text.trim(),
        'contact': contactController.text.trim(),
        'status': statusController.text.trim(),
        'location': locationController.text.trim(),
        // 'image': imageUrl,
      }).then((value) {
        Fluttertoast.showToast(msg: "Your profile is updated");
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong try again later!");
      // print(e);
      print(imageUrl);
    }
  }

  File? profileImage;

  imagePickDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Image Source'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    profileImage = File(image.path);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    profileImage = File(image.path);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: const Icon(
                  Icons.image,
                  size: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> uploadImageToFirebaseStorage(File image) async {
    String fileName = Path.basename(image.path);

    var reference =
        FirebaseStorage.instance.ref().child('profileImages/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((value) {
      imageUrl = value;
      // uploadImageToFirebaseStorage(imageUrl as File);
      updateProfilePic(imageUrl);

      debugPrint('image url ' + imageUrl);
    }).catchError((e) {
      Fluttertoast.showToast(msg: "Something went wrong try again later!");
      print("Error happen $e");
    });

    return imageUrl;
  }

  updateProfilePic(imageUrl) {
    try {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'image': imageUrl,
      }).then((value) {
        Fluttertoast.showToast(msg: "Your profile picture is updated");
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong try again later!");
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
        title: const Text(
          'Update Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Change your profile picture ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 68, 68, 130),
                    fontSize: 16,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  imagePickDialog();
                },
                child: Container(
                  width: 120,
                  height: 120,
                  margin: EdgeInsets.only(top: 35),
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(70),
                    gradient: LinearGradient(
                      colors: const [
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
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(70),
                        ),
                        child: profileImage == null
                            ? CircleAvatar(
                                radius: 56,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Color.fromARGB(255, 68, 68, 130),
                                  size: 25,
                                ),
                              )
                            : CircleAvatar(
                                radius: 56,
                                backgroundColor: Colors.white,
                                backgroundImage: FileImage(
                                  profileImage!,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 25.0,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (profileImage == null) {
                      Fluttertoast.showToast(msg: "Must select profile image");
                      return;
                    }

                    if (formkey.currentState!.validate()) {
                      Future<String> imageUrl =
                          uploadImageToFirebaseStorage(profileImage!);

                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return HomePage();
                        },
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
                  ),
                  child: Text(
                    "Change ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Update your details ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 68, 68, 130),
                    fontSize: 16,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      const Text(
                        "Change your details.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      //status
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: TextFormField(
                          controller: statusController,
                          // initialValue: status,
                          onSaved: (value) {
                            statusController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          validator: featureLen,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.face),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "Feature"),
                        ),
                      ),

                      //Username
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          controller: usernameController,
                          // initialValue: name,
                          // ..text = "${Get.arguments['username'].toString()}",
                          onSaved: (value) {
                            usernameController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                              return "Not a valid Username";
                            }
                            if (!RegExp(r'^.{5,}$').hasMatch(value)) {
                              return "Minimum 5 characters";
                            }
                            if (RegExp(r'\s{2,}').hasMatch(value)) {
                              return "Contains multiple spaces";
                            } else if (value.length > 20) {
                              return ("Maximum 20 characters");
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "Username"),
                        ),
                      ),
                      //bloodType
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          controller: bloodController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z+-]"))
                          ],
                          // initialValue: bloodType,
                          onSaved: (value) {
                            bloodController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.bloodtype),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "Blood Type"),
                          validator: wordLimit,
                        ),
                      ),
                      //location
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          controller: locationController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z]"))
                          ],
                          // initialValue: bloodType,
                          onSaved: (value) {
                            locationController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.location_city),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "Location"),
                          validator: wordLimit,
                        ),
                      ),
                      //contact
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          controller: contactController,
                          // initialValue: contact,
                          onSaved: (value) {
                            contactController.text = value!;
                          },
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "Contact"),
                          validator: privateNumber,
                        ),
                      ),

                      //edit button
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 25.0,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              updateData();

                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return HomePage();
                                },
                              ));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            backgroundColor:
                                const Color.fromRGBO(254, 109, 115, 1),
                          ),
                          child: Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
