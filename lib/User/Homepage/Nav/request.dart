// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BloodRequest extends StatefulWidget {
  const BloodRequest({super.key});

  @override
  State<BloodRequest> createState() => _BloodRequestState();
}

class _BloodRequestState extends State<BloodRequest> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('My Personal Journal');

  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? userMap;

  Future onSearch() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });
    try {
      await firebaseFirestore
          .collection('users')
          .where("bloodType", isEqualTo: _searchController.text)
          .get()
          .then((value) {
        setState(() {
          userMap = value.docs[0].data();
          isLoading = false;
        });
        print(userMap);
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "User not found!");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
        title: const Text(
          'Request Blood',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(
              child: SizedBox(
                height: size.height / 20,
                width: size.height / 20,
              ),
            )
          : Column(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: TextFormField(
                  controller: _searchController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        padding: const EdgeInsetsDirectional.only(end: 12.0),
                        icon: const Icon(Icons.done),
                        onPressed: onSearch,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelText: "Enter BloodType..."),
                ),
              ),
              userMap != null
                  ? ListTile(
                      title: Text(userMap!['bloodType']),
                      subtitle: Text(userMap!['username']),
                    )
                  : Container(),
              const SizedBox(
                height: 0,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "    Recent Messages:",
                  style: TextStyle(
                    color: Color.fromARGB(255, 68, 68, 130),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
            ]),
    );
  }
}
