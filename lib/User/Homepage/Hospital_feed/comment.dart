import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  final String image;
  const Comment({
    super.key,
    required this.text,
    required this.user,
    required this.time,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //comments
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(300),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(image),
                  ),
                ),
              ),
              const Text("  "),
              Text(
                user,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 68, 68, 130),
                ),
              ),
              const Text("  "),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
            ],
          ),

          const SizedBox(
            height: 8,
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),

          //user, posted time,
        ]),
      ),
    );
  }
}
