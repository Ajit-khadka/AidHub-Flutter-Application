
import 'package:blood_bank/User/Homepage/Message/apis.dart';
import 'package:blood_bank/model%20and%20utils/utils/message_data_formatter.dart';
import 'package:flutter/material.dart';

import '../../../model and utils/model/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _purpleMessage()
        : _redMessage();
  }

// sender message
  Widget _redMessage() {
//update last read message if sender and reciever is differet
    if (widget.message.read.isEmpty) {
      APIs.upadateMessageReadStatus(widget.message);
      // log('message read updated');
    }

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 68, 68, 130),
              border: Border.all(color: const Color.fromARGB(48, 0, 0, 255)),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          child: Text(
            widget.message.msg,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 30),
        child: Text(
          MyDateUtil.getFormattedTime(
              context: context, time: widget.message.sent),
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      )
    ]);
  }

//current user message
  Widget _purpleMessage() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        const SizedBox(
          width: 20,
        ),
        if (widget.message.read.isEmpty)
          const Icon(
            Icons.done_all_rounded,
            color: Colors.red,
            size: 20,
          ),
        const SizedBox(
          width: 5,
        ),
        Text(
          MyDateUtil.getFormattedTime(
              context: context, time: widget.message.sent),
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ]),
      Flexible(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 7),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(254, 109, 115, 1),
              border: Border.all(color: const Color.fromARGB(71, 249, 3, 11)),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30))),
          child: Text(
            widget.message.msg,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    ]);
  }
}

//39 