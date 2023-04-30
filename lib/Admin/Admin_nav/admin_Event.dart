// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model and utils/controller/data_controller.dart';
import '../Admin side event/create_event.dart';
import '../Admin side event/show_event.dart';


class Adminevent extends StatefulWidget {
  const Adminevent({super.key});

  @override
  State<Adminevent> createState() => _AdmineventState();
}

class _AdmineventState extends State<Adminevent> {
  @override
  void initState() {
    super.initState();
    EventsFeed();
    EventsIJoined();
  }

  DataController dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
          title: const Text(
            'Events',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateEventView()));
          },
          backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: const Color.fromRGBO(245, 243, 241, 1),
            child: Column(children: [
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "        Participate to interact with community !",
                  style: TextStyle(
                    color: Color.fromARGB(255, 68, 68, 130),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              EventsFeed(),
              Obx(() => dataController.isUsersLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : EventsIJoined())
            ]),
          ),
        ),
      ),
    );
  }
}
