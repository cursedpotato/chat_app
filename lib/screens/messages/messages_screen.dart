import 'package:chat_app/globals.dart';
import 'package:chat_app/screens/messages/messages_body.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MessagesScreen extends HookWidget {
  final String chatterName;
  final String chatteeName;
  final String lastSeen;
  const MessagesScreen({
    Key? key,
    required this.chatterName,
    required this.chatteeName,
    required this.lastSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // we will use getChatRoomMessages method to get the messages stream, this stream will user
    getChatRoomIdByUsernames(String a, String b) {
      if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
        // ignore: unnecessary_string_escapes
        return "$b\_$a";
      } else {
        // ignore: unnecessary_string_escapes
        return "$a\_$b";
      }
    }

    final chatroomId = getChatRoomIdByUsernames(chatteeName, chatterName);

    final future =
        useMemoized((() => DatabaseMethods().getChatRoomMessages(chatroomId)));

    Stream<QuerySnapshot>? messagesStream = useFuture(future).data;

    return Scaffold(
      appBar: buildAppBar(),
      body: StreamBuilder(
        stream: messagesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          bool hasData = snapshot.hasData;
          if (hasData) {
            return Body(
              querySnapshot: snapshot.data!.docs,
              chatteName: chatteeName,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  AppBar buildAppBar() {
    final chatteFuture =
        useMemoized(() => DatabaseMethods().getUserInfo(chatteeName));

    QuerySnapshot? chatteData = useFuture(chatteFuture).data;

    String? chattePfp = chatteData?.docs[0]["imgUrl"];
    String noUser =
        "https://hope.be/wp-content/uploads/2015/05/no-user-image.gif";
    // TODO: fix overflow problems
    return AppBar(
      title: Row(
        children: [
          ClipOval(
            child: Image.network(
              chattePfp ?? noUser,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatteeName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Active $lastSeen",
                overflow: TextOverflow.visible,
                style: const TextStyle(fontSize: 12),
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
