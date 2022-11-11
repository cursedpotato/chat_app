import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/globals.dart';
import 'package:chat_app/screens/chatroom/chatroom_body.dart';
import 'package:chat_app/services/database_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/user_model.dart';
import '../home/home_screen.dart';

class MessagesScreen extends HookConsumerWidget {
  const MessagesScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // we will use getChatRoomMessages method to get the messages stream, this stream will user
    UserModel chatteeModel = ref.watch(userModelProvider);

    final chatroomId = getChatRoomIdByUsernames(chatteeModel.name!, chatterUsername!);

    final future =
        useMemoized(() => DatabaseMethods().getChatRoomMessages(chatroomId));

    Stream<QuerySnapshot>? messagesStream = useFuture(future).data;

    return Scaffold(
      appBar: buildAppBar(chatteeModel),
      body: StreamBuilder(
        stream: messagesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          bool hasData = snapshot.hasData;
          if (hasData) {
            return Body(
              querySnapshot: snapshot.data!.docs,
              chatteName: chatteeModel.name!,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  AppBar buildAppBar(UserModel chatteeModel) {
    
    String lastSeen = timeago.format(chatteeModel.lastSeenDate!);

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: chatteeModel.pfpUrl ?? noImage,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatteeModel.name!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Active $lastSeen",
                overflow: TextOverflow.visible,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.local_phone),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam),
          ),
        ],
      ),
    );
  }
}
