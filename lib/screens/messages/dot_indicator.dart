import 'package:chat_app/globals.dart';
import 'package:flutter/material.dart';

import '../../models/message_model.dart';

class MessageStatusDot extends StatelessWidget {
  final MessageStatus status;
  const MessageStatusDot({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.notSent:
          return kErrorColor;
        case MessageStatus.notViewed:
          return Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.1);
        case MessageStatus.viewed:
          return kPrimaryColor;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: const EdgeInsets.only(left: kDefaultPadding / 2, top: 18),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.notSent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}