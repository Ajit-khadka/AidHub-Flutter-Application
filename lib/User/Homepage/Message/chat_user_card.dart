import 'package:flutter/material.dart';

import '../../../model and utils/model/chat_user.dart';
import '../../../model and utils/model/message.dart';
import '../../../model and utils/utils/message_data_formatter.dart';
import '../profile/visitpage/profile_visit.dart';
import 'apis.dart';
import 'chat_screen.dart';

//card to represent a single user in home screen
class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message info (if null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      // color: Colors.blue.shade100,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(user: widget.user)));
          },
          child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

                if (list.isNotEmpty) _message = list[0];
                return ListTile(
                    leading: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    ProfileVisit(user: widget.user)));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(300),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.user.image),
                        ),
                      ),
                    ),
                    title: Text(widget.user.username),
                    subtitle: Text(
                      widget.user.status,
                      maxLines: 1,
                    ),
                    trailing: _message == null
                        ? null
                        : _message!.read.isEmpty &&
                                _message!.fromId != APIs.user.uid
                            ? Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 252, 2, 2),
                                    borderRadius: BorderRadius.circular(10)),
                              )

                            //sent time
                            : Text(
                                MyDateUtil.getLastMessageTime(
                                    context: context, time: _message!.sent),
                                style: const TextStyle(color: Colors.black54),
                              ));
              })),
    );
   
  }
}
