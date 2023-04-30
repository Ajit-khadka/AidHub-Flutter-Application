// ignore_for_file: non_constant_identifier_names, unused_local_variable


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model and utils/controller/data_controller.dart';
import '../../User side Event/user_show_event.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  void initState() {
    super.initState();
    UserEventsFeed();
    UserEventsIJoined();
  }

  DataController dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
          title: const Text(
            'Events',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
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
              UserEventsFeed(),
              Obx(() => dataController.isUsersLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : UserEventsIJoined())
            ]),
          ),
        ),
      ),
    );
  }
}
