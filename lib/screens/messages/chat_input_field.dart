import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:random_string/random_string.dart';

import '../../globals.dart';
import '../../services/database.dart';

class ChatInputField extends HookWidget {
  final String chatteeName;
  const ChatInputField({
    Key? key,
    required this.chatteeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String messageId = "";
    String? chatterPfp = FirebaseAuth.instance.currentUser?.photoURL;
    TextEditingController messageController = useTextEditingController();
    getChatRoomIdByUsernames(String a, String b) {
      if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
        // ignore: unnecessary_string_escapes
        return "$b\_$a";
      } else {
        // ignore: unnecessary_string_escapes
        return "$a\_$b";
      }
    }

    String chatRoomId = getChatRoomIdByUsernames(chatteeName, chatterUsername!);

    addMessage(bool sendClicked) {
      if (messageController.text != "") {
        String message = messageController.text;

        var lastMessageTs = DateTime.now();

        Map<String, dynamic> messageInfoMap = {
          "message": message,
          "sendBy": chatterUsername,
          "ts": lastMessageTs,
          "imgUrl": chatterPfp,
          "messageType": "text",
        };

        //messageId
        if (messageId == "") {
          messageId = randomAlphaNumeric(12);
        }

        DatabaseMethods()
            .addMessage(chatRoomId, messageId, messageInfoMap)
            .then(
          (value) {
            Map<String, dynamic> lastMessageInfoMap = {
              "lastMessage": message,
              "lastMessageSendTs": lastMessageTs,
              "lastMessageSendBy": chatterUsername,
            };

            DatabaseMethods()
                .updateLastMessageSend(chatRoomId, lastMessageInfoMap);

            if (sendClicked) {
              messageController.text = "";
              messageId = "";
            }
          },
        );
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 32,
              color: const Color(0xFF087949).withOpacity(0.08)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.mic, color: kPrimaryColor),
          const SizedBox(width: kDefaultPadding),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  // May add in future
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(
                  //     Icons.sentiment_satisfied_alt_outlined,
                  //     color: Theme.of(context)
                  //         .textTheme
                  //         .bodyText1
                  //         ?.color
                  //         ?.withOpacity(0.64),
                  //   ),
                  // ),
                  const SizedBox(width: kDefaultPadding / 4),
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      maxLines: 1,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                          hintText: "Type message", border: InputBorder.none),
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.attach_file,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              addMessage(true);
            },
            child: const Icon(
              Icons.send,
            ),
          )
        ],
      ),
    );
  }
}
