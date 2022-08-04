import 'package:chat_app/globals.dart';
import 'package:chat_app/screens/messages/messages_body.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  final String chatterName;
  final String chatteeName;
  const MessagesScreen({
    Key? key,
    required this.chatterName,
    required this.chatteeName,
  }) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {

  Stream<QuerySnapshot>? messagesStream;

  QuerySnapshot? chatteeInfo;


  // we will use getChatRoomMessages method to get the messages stream, this stream will user
  //
  // we will use getUser
  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      // ignore: unnecessary_string_escapes
      return "$b\_$a";
    } else {
      // ignore: unnecessary_string_escapes
      return "$a\_$b";
    }
  }

  toExecute () async {

    final chatroomId = getChatRoomIdByUsernames(widget.chatteeName, widget.chatterName);
    messagesStream = await DatabaseMethods().getChatRoomMessages(chatroomId);
    chatteeInfo = await DatabaseMethods().getUserInfo(widget.chatteeName);
  }

  @override
  void initState() {
    toExecute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: const Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          // TODO: implement future builder here
          const CircleAvatar(
            backgroundImage: NetworkImage(
              "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
            ),
          ),
          const SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.chatteeName,
                style: const TextStyle(fontSize: 16),
              ),
              // TODO: implement conditional to see if user was active
              const Text(
                "Active 3 minutes ago",
                style: TextStyle(fontSize: 12),
              ),
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.local_phone),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.videocam),
        ),
        const SizedBox(
          width: kDefaultPadding / 2,
        )
      ],
    );
  }
}
