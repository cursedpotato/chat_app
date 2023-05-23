import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../models/message_model.dart';
import '../../../viewmodel/chat_input_viewmodel.dart';
import '../../../viewmodel/messages_viewmodel.dart';

class CustomSendButton extends HookConsumerWidget {
  const CustomSendButton({
    Key? key,
    this.messageController,
  }) : super(key: key);

  // Parameters are optional because the app is not always in "send-message-state"
  final TextEditingController? messageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon = useState(Icons.mic);
    final inputCtrl = ref.watch(chatInputViewModelProvider);

    // -----------------------
    // Animation related logic
    // -----------------------
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 180));

    late final offsetAnimation = useMemoized(
      () => Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(1.5, 0.0),
      ).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceInOut,
      )),
    );

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        icon.value = Icons.mic;
        if (inputCtrl.showMicIcon) icon.value = Icons.mic;
        if (!inputCtrl.showMicIcon) icon.value = Icons.send;
        animationController.reverse();
      }
    });

    void toggle() {
      if (messageController == null) return;
      // The animation triggers when the user types, but also when the widget gets drawn
      // it looks kind of annoying when the animation triggers everytime, so we set the canAnimateProvider when the user types to prevent,
      // this annoying behaviorf
      final inputCtrlR = ref.read(chatInputViewModelProvider.notifier);

      if (messageController!.text.isEmpty) {
        animationController.forward();
        inputCtrlR.updateShowMicIcon(true);
        inputCtrlR.updateCanAnimate(true);
      }

      if (messageController!.text.isNotEmpty) {
        if (inputCtrl.canButtonAnimate) {
          animationController.forward();
          inputCtrlR.updateCanAnimate(false);
        }
        inputCtrlR.updateShowMicIcon(false);
      }
    }

    // We listen input to toggle the mic
    useEffect(() {
      messageController?.addListener(toggle);
      return () => messageController?.removeListener(toggle);
    });

    return SlideTransition(
      position: offsetAnimation,
      child: IconButton(
        onPressed: inputCtrl.showMicIcon
            ? () {
                log("ayo");
              }
            : () => addMessage(messageController!, ref),
        icon: Icon(icon.value),
      ),
    );
  }
}

addMessage(
  TextEditingController messageController,
  WidgetRef ref,
) async {
  final message = ChatMessageModel.textMessage(
    id: const Uuid().v1(),
    message: messageController.text,
  );
  messageController.clear();
  await ref.read(messagesViewModelProvider.notifier).uploadMessage(message);
}
