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
    final controller = AnimateIconController();

    final toggle = useState(false);

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
          mediaMenu(controller, toggle),
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
              onPressed: () => addMessage(true), icon: const Icon(Icons.send))
        ],
      ),
    );
  }

  Row mediaMenu(controller, toggle) {
    return Row(
      children: [
        AnimateIcons(
          startIcon: Icons.arrow_forward_ios_rounded,
          endIcon: Icons.apps,
          onStartIconPress: () {
            toggle.value = !toggle.value;
            print("Clicked on Add Icon");
            return true;
          },
          onEndIconPress: () {
            toggle.value = !toggle.value;
            print("Clicked on Close Icon");
            return true;
          },
          controller: controller,
        ),
        toggle == true ? Row(children: multimedia()) : Container()
      ],
    );
  }

  List<Widget> multimedia() {
    final media = <Widget>[
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
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.mic),
      ),
    ];
    return media;
  }
}
