import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../core/theme/sizes.dart';
import '../../../models/message_model.dart';
import '../message_types/export_message_types.dart';
import 'message_status_dot_widget.dart';

class Message extends HookWidget {
  final ChatMessageModel message;
  const Message({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget messageContent(ChatMessageModel message) {
      final map = {
        ChatMessageType.text: TextMessage(message),
        ChatMessageType.audio: AudioMessage(message),
        ChatMessageType.gallery: GalleryMessageWidget(message),
      };
      Widget type = map[message.messageType] ?? const SizedBox();
      return type;
    }

    return Focus(
      autofocus: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
        child: Row(
          crossAxisAlignment: message.isSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.center,
          mainAxisAlignment: message.isSender
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!message.isSender) ...[
              Container(
                margin: const EdgeInsets.only(right: kDefaultPadding / 2),
                child: CircleAvatar(
                  radius: 12,
                  backgroundImage: CachedNetworkImageProvider(message.pfpUrl),
                ),
              )
            ],
            messageContent(message),
            if (message.isSender)
              MessageStatusDot(
                status: message.messageStatus,
              ),
          ],
        ),
      ),
    );
  }
}
