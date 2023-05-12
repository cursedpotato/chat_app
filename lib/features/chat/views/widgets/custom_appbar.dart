import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/home/views/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/routes/strings.dart';

AppBar buildChatroomAppbar(WidgetRef ref) {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: noImage,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "userModel.name!",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                // TODO: add last seen
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
