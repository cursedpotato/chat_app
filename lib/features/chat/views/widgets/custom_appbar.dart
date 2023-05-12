import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/home/viewmodel/chattees_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/routes/strings.dart';

AppBar buildChatroomAppbar(WidgetRef ref) {
  // TODO: appbar for chatroom with multiple people
  final userModel = ref.watch(chatteesViewModel).chattes.first;
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: userModel.profilePic,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userModel.username,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              ),
              const Text(
                // TODO: create util for date time
                "Active ",
                overflow: TextOverflow.visible,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
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
