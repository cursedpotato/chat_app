
import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ChatMesssageModel message;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight: double.infinity,
          maxWidth: MediaQuery.of(context).size.width * 0.4),
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(message.isSender! ? 1 : 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      // child: AnimatedTextKit(
      //   animatedTexts: [
      //     TypewriterAnimatedText(
      //       message.message!,
      //       textStyle: TextStyle(
      //           fontSize: 12,
      //           color: message.isSender!
      //               ? Colors.white
      //               : Theme.of(context).textTheme.bodyText1?.color),
      //     ),
      //   ],
      //   totalRepeatCount: 1,
      // ),
      child: Text(
        message.message!,
        softWrap: true,
        style: TextStyle(
          fontSize: 12,
          color: message.isSender!
              ? Colors.white
              : Theme.of(context).textTheme.bodyText1?.color,
        ),
      ),
    );
  }
}
