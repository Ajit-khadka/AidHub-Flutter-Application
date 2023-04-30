// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import '../Message/chats_component.dart';
// // import '../Message/compose_screen/compose_screen.dart';
// // import '../Message/home_controller.dart';

// class BloodRequest extends StatefulWidget {
//   const BloodRequest({super.key});

//   @override
//   State<BloodRequest> createState() => _BloodRequestState();
// }

// class _BloodRequestState extends State<BloodRequest> {
//   @override
//   Widget build(BuildContext context) {
//     //init home controller
//     // var controller = Get.put(HomeController());

//     return SafeArea(
//       child: DefaultTabController(
//         length: 1,
//         child: Scaffold(
//           backgroundColor: const Color.fromRGBO(245, 243, 241, 1),
//           appBar: AppBar(
//             centerTitle: true,
//             backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
//             title: const Text(
//               'Messages',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             automaticallyImplyLeading: false,
//           ),
//           floatingActionButton: FloatingActionButton(
//             backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
//             onPressed: () {
//               //compose screen

//               // Get.to(() => const ComposeScreen(),
//               //     transition: Transition.downToUp);
//             },
//             child: const Icon(Icons.edit),
//           ),
//           body: Column(
//             children: [
//               Expanded(
//                   child: Row(children: [
//                 Expanded(
//                   child: Container(
//                     clipBehavior: Clip.antiAlias,
//                     margin: const EdgeInsets.only(bottom: 8),
//                     decoration: const BoxDecoration(
//                         borderRadius:
//                             BorderRadius.only(bottomLeft: Radius.circular(12)),
//                         color: Colors.white),
//                     child: TabBarView(
//                       physics: const BouncingScrollPhysics(),
//                       children: [
//                         Container(
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                           ),
//                           // child: chatsComponent(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ]))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
