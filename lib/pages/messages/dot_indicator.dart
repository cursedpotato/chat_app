import 'package:chat_app/globals.dart';
import 'package:flutter/material.dart';

import 'messages_body.dart';
class MessageStatusDot extends StatelessWidget {
  final MessageStatus status;
  const MessageStatusDot({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? dotColor(MessageStatus status) {
      // if(status == MessageStatus.not_sent) kErrorColor;
      switch (status) {
        case MessageStatus.not_sent:
          return kErrorColor;
        case MessageStatus.not_view:
          return Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.1);
        case MessageStatus.viewed:
          return kPrimaryColor;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: kDefaultPadding / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}