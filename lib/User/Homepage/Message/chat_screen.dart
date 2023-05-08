import 'package:blood_bank/model%20and%20utils/model/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model and utils/model/message.dart';
import '../../../model and utils/utils/message_data_formatter.dart';
import '../profile/visitpage/profile_visit.dart';
import 'apis.dart';
import 'message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color.fromRGBO(245, 243, 241, 1),
            appBar: AppBar(
              flexibleSpace: _appBar(),
              backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                              child: CircularProgressIndicator());

                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;

                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          debugPrint(APIs.user.uid);

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                itemCount: _list.length,
                                padding: const EdgeInsets.only(top: 10),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(message: _list[index]);
                                });
                          } else {
                            return const Center(
                              child: Text(
                                "Say hi! 👋",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 68, 68, 130),
                                  wordSpacing: 0.5,
                                ),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),
                _chatInput()
              ],
            )));
  }

  Widget _appBar() {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileVisit(user: widget.user)));
        },
        child: StreamBuilder(
            stream: APIs.getUserInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              return Row(
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.user.image),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                    height: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //username

                      Text(
                        list.isNotEmpty
                            ? list[0].username
                            : widget.user.username,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 2),

                      //last seen time of user
                      Text(
                          list.isNotEmpty
                              ? list[0].isOnline
                                  ? 'Online'
                                  : MyDateUtil.getLastActiveTime(
                                      context: context,
                                      lastActive: list[0].lastActive)
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: widget.user.lastActive),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white)),
                    ],
                  )
                ],
              );
            }));
  }

  Widget _chatInput() {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Color.fromRGBO(254, 109, 115, 1),
                      )),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: "Type Something...",
                          hintStyle:
                              TextStyle(color: Color.fromARGB(84, 68, 68, 130)),
                          border: InputBorder.none),
                    ),
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isEmpty) {
                Get.snackbar('Opps', "Message is Required.",
                    colorText: const Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: const Color.fromRGBO(254, 109, 115, 1));
              }
              if (RegExp(r'\s{2,}').hasMatch(_textController.text)) {
                Get.snackbar('Opps', "Message contains multiple spaces",
                    colorText: const Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: const Color.fromRGBO(254, 109, 115, 1));
              } else if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text);
                _textController.text = '';
              }
              //else {
              //   Get.snackbar('Opps', "Something went wrong!!",
              //       colorText: const Color.fromARGB(255, 255, 255, 255),
              //       backgroundColor: const Color.fromRGBO(254, 109, 115, 1));
              // }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: const Color.fromRGBO(254, 109, 115, 1),
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ]),
      );
    });
  }
}

//33
