import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../globals.dart';
import '../../../services/database.dart';

final sliderPosition = StateProvider.autoDispose((ref) => 0.0);
final showMic = StateProvider.autoDispose((ref) => true);
final showAudioWidget = StateProvider.autoDispose((ref) => false);
final wasAudioDiscarted = StateProvider.autoDispose((ref) => false);

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

    // This controls whether the mic icon is shown or not
    // ignore: todo
    // TODO: may make this all global to be consumed by a consumer widget
    // ValueNotifier<bool> showMic = useValueNotifier(true);
    // ValueNotifier<bool> showAudioWidget = useState(false);
    // ValueNotifier<bool> wasAudioDiscarted = useState(false);

    // We track input to toggle the mic

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
            color: const Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: Consumer(
        builder: (context, ref, child) {
          List<Widget> rowList = [];
          return Row(children: rowList);
        },
      ),
      // child: Row(
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   children: [
      //     showAudioWidget.value ? const MicWidget() : const MediaMenu(),

      //     showAudioWidget.value
      //         ? const SizedBox()
      //         : CustomTextField(messageController: messageController),
      //     // Custom send button
      //     CustomSendButton(
      //       showMic: showMic,
      //       showAudioWidget: showAudioWidget,
      //       addMessage: addMessage,
      //       fingerDown: fingerDown,
      //       fingerOff: fingerOff,
      //     )
      //   ],
      // ),
    );
  }
}

class CustomSendButton extends HookWidget {
  const CustomSendButton({
    Key? key,
    required this.addMessage,
    required this.messageController,
  }) : super(key: key);

  final void Function(bool) addMessage;
  final TextEditingController messageController;

  @override
  Widget build(BuildContext context) {
    // Slide Transition animation related
    final showMic = useState(true);
    final icon = useState(Icons.mic);

    void toggle() {
      if (messageController.text.isEmpty) showMic.value = true;
      if (messageController.text.isNotEmpty) showMic.value = false;
    }

    useEffect(() {
      messageController.addListener(toggle);
      return () => messageController.removeListener(toggle);
    });

    late final toggleTransitionController =
        useAnimationController(duration: const Duration(milliseconds: 180));
    late final Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: toggleTransitionController,
      curve: Curves.bounceInOut,
    ));

    toggleTransitionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (showMic.value) icon.value = Icons.mic;
        if (!showMic.value) icon.value = Icons.send;
        toggleTransitionController.reverse();
      }
    });

    return Consumer(
      builder: (context, ref, child) {
        // This prevents the slide transition to trigger everytime the user taps over the mic
        if (!ref.watch(showAudioWidget)) toggleTransitionController.forward();

        // ignore: no_leading_underscores_for_local_identifiers, unused_local_variable
        bool _showAudioWidget = ref.read(showAudioWidget.notifier).state;

        void fingerDown(PointerEvent details) {
          if (showMic.value) _showAudioWidget = true;
        }

        void fingerOff(PointerEvent details) {
          if (showMic.value) _showAudioWidget = false;
        }

        void updateLocation(PointerEvent details) {
          // The listener will update the positon of the slider that is found in the recording Widget
          ref.read(sliderPosition.notifier).state = details.position.dx;
        }

        return Listener(
          onPointerMove: updateLocation,
          onPointerDown: fingerDown,
          onPointerUp: fingerOff,
          child: Transform(
            transform: Matrix4.identity(),
            child: SlideTransition(
              position: offsetAnimation,
              child: IconButton(
                onPressed: showMic.value
                    ? () => debugPrint('Add function')
                    : () => addMessage(true),
                icon: Icon(icon.value),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.messageController,
  }) : super(key: key);

  final TextEditingController messageController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(40),
        ),
        child: TextField(
          autofocus: true,
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
    );
  }
}
