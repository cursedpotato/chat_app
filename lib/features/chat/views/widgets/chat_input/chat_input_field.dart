import 'package:chat_app/features/chat/models/message_model.dart';
import 'package:chat_app/features/chat/viewmodel/chat_input_viewmodel.dart';
import 'package:chat_app/features/chat/views/widgets/chat_input/audio_input/recording_widget.dart';
import 'package:chat_app/features/chat/views/widgets/chat_input/text_input/text_input_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/theme/sizes.dart';
import '../../../viewmodel/messages_viewmodel.dart';
import 'functions_menu/media_menu_widget.dart';

class ChatInputField extends HookConsumerWidget {
  const ChatInputField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController messageController = useTextEditingController();

    final inputCtrl = ref.watch(chatInputViewModelProvider);

    // ------------------------------------------------------------
    // Fuction that displays different widgets as app state changes
    // ------------------------------------------------------------
    List<Widget> rowList() {
      if (inputCtrl.wasRecoringDismissed || inputCtrl.showControlRec) {
        return [const RecordingWidget()];
      }

      if (inputCtrl.showRecordingWidget) {
        return [const RecordingWidget(), const _CustomSendButton()];
      }

      return [
        const MediaMenu(),
        ChatRoomTextField(messageController: messageController),
        _CustomSendButton(
          textEditingController: messageController,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: rowList(),
      ),
    );
  }
}

class _CustomSendButton extends HookConsumerWidget {
  const _CustomSendButton({
    Key? key,
    this.textEditingController,
  }) : super(key: key);

  // Parameters are optional because the app is not always in "send-message-state"
  final TextEditingController? textEditingController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon = useState(Icons.mic);
    final inputCtrl = ref.watch(chatInputViewModelProvider);

    // -----------------------
    // Animation related logic
    // -----------------------
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 180));

    late final Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceInOut,
    ));

    if (inputCtrl.canAnimate) {
      animationController.forward();
      if (!inputCtrl.showMicIcon) animationController.forward();
    }

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        icon.value = Icons.mic;
        if (!inputCtrl.showMicIcon) icon.value = Icons.send;
        animationController.reverse();
      }
    });

    addMessage(
      TextEditingController messageController,
    ) async {
      final message = ChatMessageModel.textMessage(
        id: const Uuid().v1(),
        message: messageController.text,
      );
      messageController.clear();
      await ref.read(messagesViewModelProvider.notifier).uploadMessage(message);
    }

    return Listener(
      onPointerUp: (event) {
        ref.read(chatInputViewModelProvider.notifier).fingerDown(event);
      },
      onPointerDown: (event) {
        ref.read(chatInputViewModelProvider.notifier).fingerOff(event);
      },
      onPointerMove: (event) {
        ref.read(chatInputViewModelProvider.notifier).updateLocation(event);
      },
      child: SlideTransition(
        position: offsetAnimation,
        child: IconButton(
          onPressed: inputCtrl.showMicIcon
              ? () {}
              : () => addMessage(textEditingController!),
          icon: Icon(icon.value),
        ),
      ),
    );
  }
}
