import 'package:chat_app/pages/chats/chat_body.dart';
import 'package:chat_app/views/chatscreen.dart';

import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
      
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Text("Chats"),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        )
      ],
    );
  }
}


