import 'package:animate_icons/animate_icons.dart';
import 'package:chat_app/screens/chatroom/chat_input/media_menu_widget.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:uuid/uuid.dart';

import '../../../globals.dart';
import '../../../services/database.dart';

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

    // This controls whether the mic icon is show or not
    ValueNotifier<bool> showMic = useValueNotifier(true);

    // We track input to toggle the mic
    void toggle() {
      if (messageController.text.isEmpty) showMic.value = true;
      // To avoid the var being constantly called
      var length = messageController.text.isNotEmpty;
      if (length) showMic.value = false;
    }

    useEffect(() {
      messageController.addListener(toggle);
      return () => messageController.removeListener(toggle);
    });

    void addMessage(bool sendClicked) {
      if (messageController.text.isEmpty) return;

      String message = messageController.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": chatterUsername,
        "ts": lastMessageTs,
        "imgUrl": chatterPfp,
        "resUrl": '',
        "messageType": "text",
      };

      //messageId
      if (messageId == "") {
        messageId = const Uuid().v1();
      }

      DatabaseMethods().addMessage(chatRoomId, messageId, messageInfoMap).then(
        (value) {
          Map<String, dynamic> lastMessageInfoMap = {
            "lastMessage": message,
            "lastMessageSendTs": lastMessageTs,
            "lastMessageSendBy": chatterUsername,
          };

          // We update the user activity
          DatabaseMethods()
              .updateLastMessageSend(chatRoomId, lastMessageInfoMap);

          if (sendClicked) {
            messageController.text = "";
            messageId = "";
          }
        },
      );
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
          MediaMenu(),
          // TextField
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
                  hintText: "Type a message",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          HookBuilder(
            builder: (context) {
              final toggle = useValueListenable(showMic);
              final icon = useState(Icons.mic);

              late final animationController = useAnimationController(
                  duration: const Duration(milliseconds: 180));
              late final Animation<Offset> offsetAnimation = Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(1, 0.0),
              ).animate(CurvedAnimation(
                parent: animationController,
                curve: Curves.bounceInOut,
              ));

              animationController.addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  if (toggle) icon.value = Icons.mic;
                  if (!toggle) icon.value = Icons.send;
                  animationController.reverse();
                }
              });

              if (!toggle) animationController.forward();
              if (toggle) animationController.forward();

              return SlideTransition(
                position: offsetAnimation,
                child: IconButton(
                    onPressed: toggle
                        ? () => debugPrint('Add function')
                        : () => addMessage(true),
                    icon: Icon(icon.value)),
              );
            },
          )
        ],
      ),
    );
  }

}
