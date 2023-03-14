import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
        title: const Text(
          'Events',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
    );
  }
}


//  Icon customIcon = const Icon(Icons.search);
//   Widget customSearchBar = const Text('My Personal Journal');

//   bool isLoading = false;
//   final TextEditingController _searchController = TextEditingController();
//   Map<String, dynamic>? userMap;

//   Future onSearch() async {
//     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

//     setState(() {
//       isLoading = true;
//     });
//     try {
//       await firebaseFirestore
//           .collection('users')
//           .where("bloodType", isEqualTo: _searchController.text)
//           .get()
//           .then((value) {
//         setState(() {
//           userMap = value.docs[0].data();
//           isLoading = false;
//         });
//         print(userMap);
//       });
//     } catch (e) {
//       Fluttertoast.showToast(msg: "User not found!");
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
//         title: const Text(
//           'Request Blood',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         automaticallyImplyLeading: false,
//       ),
//       body: isLoading
//           ? Center(
//               child: SizedBox(
//                 height: size.height / 20,
//                 width: size.height / 20,
//               ),
//             )
//           : Column(children: [
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//                 child: TextFormField(
//                   controller: _searchController,
//                   textInputAction: TextInputAction.next,
//                   decoration: InputDecoration(
//                       suffixIcon: IconButton(
//                         padding: const EdgeInsetsDirectional.only(end: 12.0),
//                         icon: const Icon(Icons.done),
//                         onPressed: onSearch,
//                       ),
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       labelText: "Enter BloodType..."),
//                 ),
//               ),
//               userMap != null
//                   ? ListTile(
//                       title: Text(userMap!['bloodType']),
//                       subtitle: Text(userMap!['username']),
//                     )
//                   : Container(),
//               const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   '    Create Request\n',
//                   textAlign: TextAlign.left,
//                   style: TextStyle(
//                       fontWeight: FontWeight.normal,
//                       fontSize: 20,
//                       color: Color.fromARGB(255, 68, 68, 130),
//                       fontFamily: 'Poppins'),
//                 ),
//               ),
//               const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     '    Blood Requests',
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                         fontWeight: FontWeight.normal,
//                         fontSize: 20,
//                         color: Color.fromARGB(255, 68, 68, 130),
//                         fontFamily: 'Poppins'),
//                   ))
//             ]),
//     );
//   }
// }

