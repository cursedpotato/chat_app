import 'package:animate_icons/animate_icons.dart';
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
    String chatRoomId = getChatRoomIdByUsernames(chatteeName, chatterUsername!);

    final toggle = useValueNotifier(false);

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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          mediaMenu(toggle),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextField(
                controller: messageController,
                maxLength: 800,
                minLines: 1,
                maxLines: 5, // This way the textfield grows
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  // This hides the counter that appears when you set a chat limit
                  counterText: "",
                  hintText: "Type message",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => addMessage(true),
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }

  Widget mediaMenu(ValueNotifier<bool> toggle) {
    final controller = AnimateIconController();
    const duration = Duration(milliseconds: 100);
    return HookBuilder(
      builder: (BuildContext context) {
        bool isSelected = useValueListenable(toggle);
        return Row(  
          children: [
            AnimateIcons(
              duration: duration,
              startIcon: Icons.arrow_forward_ios_rounded,
              endIcon: Icons.apps_rounded,
              onStartIconPress: () {
                debugPrint("mediaMenu: Shrink");
                toggle.value = !toggle.value;
                return true;
              },
              onEndIconPress: () {
                debugPrint("mediaMenu: Grow");
                toggle.value = !toggle.value;

                return true;
              },
              controller: controller,
            ),
            AnimatedContainer(
                
                height: 24,
                width: isSelected ? 100.0 : 0.0,
                duration: duration,
                curve: Curves.fastOutSlowIn,
            ),
          ],
        );
      },
    );
  }

  Widget multimedia(bool selected) {
    Tween<Offset> offset =
        Tween(begin: const Offset(1, 0), end: const Offset(0, 0));
    return AnimatedList(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index, animation) {
        return SlideTransition(
          position: animation.drive(offset),
          child: const SizedBox(),
        );
      },
    );
  }
}
