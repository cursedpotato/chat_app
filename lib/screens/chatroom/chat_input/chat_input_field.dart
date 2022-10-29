import 'package:chat_app/screens/chatroom/chat_input/recording_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../globals.dart';
import '../../../services/database.dart';
import 'media_menu_widget.dart';

class ChatInputField extends HookConsumerWidget {
  final String chatteeName;
  const ChatInputField({
    Key? key,
    required this.chatteeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String messageId = "";
    TextEditingController messageController = useTextEditingController();
    final showMic = useState(true);

    late final double screenWidth = MediaQuery.of(context).size.width;
    // Listener related functions
    void fingerDown(PointerEvent details) {
      if (!showMic.value) return;
      ref.read(showAudioWidget.notifier).state = true;
    }

    void fingerOff(PointerEvent details) {
      if (!showMic.value) return;
      // If the animation is in progress we don't want to show everything else yet
      if (ref.watch(wasAudioDiscarted)) return;
      ref.read(showAudioWidget.notifier).state = false;
    }

    void updateLocation(PointerEvent details) {
      ref.read(sliderPosition.notifier).state = details.position.dx;
      if (details.position.dx < screenWidth * 0.5) {
        ref.read(wasAudioDiscarted.notifier).state = true;
      }
    }

    void addMessage(bool sendClicked) {
      if (messageController.text.isEmpty) return;

      String message = messageController.text;
      String? chatterPfp = FirebaseAuth.instance.currentUser?.photoURL;
      String chatRoomId =
          getChatRoomIdByUsernames(chatteeName, chatterUsername!);
      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "imgUrl": chatterPfp,
        "sendBy": chatterUsername,
        "ts": lastMessageTs,
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

    List<Widget> rowList() {
      if (ref.watch(wasAudioDiscarted)) return [const RecordingWidget()];
      if (ref.watch(showAudioWidget)) {
        return [
          const RecordingWidget(),
          CustomSendButton(
            showMic: showMic,
            fingerDown: fingerDown,
            fingerOff: fingerOff,
            updateLocation: updateLocation,
          )
        ];
      }
      return [
        const MediaMenu(),
        ChatRoomTextField(messageController: messageController),
        CustomSendButton(
          showMic: showMic,
          addMessage: addMessage,
          messageController: messageController,
          fingerDown: fingerDown,
          fingerOff: fingerOff,
          updateLocation: updateLocation,
        )
      ];
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
        child: Row(children: rowList()));
  }
}

class CustomSendButton extends HookWidget {
  const CustomSendButton({
    Key? key,
    this.messageController,
    this.addMessage,
    this.updateLocation,
    this.fingerDown,
    this.fingerOff,
    required this.showMic,
  }) : super(key: key);

  // Parameters are optional because the app is not always in "send-message-state"
  final TextEditingController? messageController;
  final void Function(bool)? addMessage;
  final void Function(PointerEvent)? updateLocation;
  final void Function(PointerEvent)? fingerDown;
  final void Function(PointerEvent)? fingerOff;
  final ValueNotifier<bool> showMic;

  @override
  Widget build(BuildContext context) {
    // Slide Transition animation related

    final icon = useState(Icons.mic);

    void toggle() {
      if (messageController!.text.isEmpty) showMic.value = true;
      if (messageController!.text.isNotEmpty) showMic.value = false;
    }

    // We listen input to toggle the mic

    late final animationController =
        useAnimationController(duration: const Duration(milliseconds: 180));

    useEffect(() {
      messageController?.addListener(toggle);
      return () => messageController?.removeListener(toggle);
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (showMic.value) icon.value = Icons.mic;
        if (!showMic.value) icon.value = Icons.send;
        animationController.reverse();
      }
    });
    late final Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceInOut,
    ));

    return Consumer(
      builder: (context, ref, child) {
        return Listener(
          // The listener will update the positon of the slider that is found in the recording Widget
          onPointerUp: fingerOff,
          onPointerDown: fingerDown,
          onPointerMove: updateLocation,
          child: SlideTransition(
            position: offsetAnimation,
            child: IconButton(
              onPressed: showMic.value ? () {} : () => addMessage!(true),
              icon: Icon(icon.value),
            ),
          ),
        );
      },
    );
  }
}

class ChatRoomTextField extends StatelessWidget {
  const ChatRoomTextField({
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
