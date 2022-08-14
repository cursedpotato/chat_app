import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

class AudioMessage extends StatelessWidget {
  final ChatMessage message;
  const AudioMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      margin: const EdgeInsets.only(top: kDefaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding / 2.5,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: kPrimaryColor.withOpacity(message.isSender ? 1 : 0.1)),
      child: Row(
        children: [
          Icon(Icons.play_arrow,
              color: message.isSender ? Colors.white : kPrimaryColor),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 2,
                  color: message.isSender
                      ? Colors.white
                      : kPrimaryColor.withOpacity(0.4),
                ),
                Positioned(
                  left: 0,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: message.isSender? Colors.white : kPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              ],
            ),
          ),
          Text(
            "0:37",
            style: TextStyle(
              fontSize: 12,
              color: message.isSender ? Colors.white : null,
            ),
          )
        ],
      ),
    );
  }
}