import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import '../../../models/message_model.dart';

class MessageStatusDot extends StatelessWidget {
  final MessageStatus status;
  const MessageStatusDot({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      final map = {
        MessageStatus.notSent: kErrorColor,
        MessageStatus.sent:
            Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.1),
        MessageStatus.viewed: kPrimaryColor,
      };

      final result = map[status] ?? Colors.transparent;
      return result;
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
