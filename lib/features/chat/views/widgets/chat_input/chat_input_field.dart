import 'package:chat_app/features/chat/viewmodel/chat_input_viewmodel.dart';
import 'package:chat_app/features/chat/views/widgets/chat_input/custom_send_button.dart';
import 'package:chat_app/features/chat/views/widgets/chat_input/text_input/text_input_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/theme/sizes.dart';
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
    final screenSize = MediaQuery.of(context).size;
    List<Widget> rowList() {
      // if (inputCtrl.wasRecoringDismissed || inputCtrl.showControlRec) {
      //   return [const RecordingWidget()];
      // }

      // if (inputCtrl.showRecordingWidget) {
      //   return [
      //     const RecordingWidget(),
      //     _listenButton(ref, screenSize, messageController),
      //   ];
      // }

      return [
        const MediaMenu(),
        ChatRoomTextField(messageController: messageController),
        _listenButton(ref, screenSize, messageController),
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

  Listener _listenButton(
      WidgetRef ref, Size screenSize, TextEditingController messageController) {
    return Listener(
      onPointerUp: (event) {
        ref.read(chatInputViewModelProvider.notifier).fingerOff(event);
      },
      onPointerDown: (event) {
        ref.read(chatInputViewModelProvider.notifier).fingerDown(event);
      },
      onPointerMove: (event) {
        ref
            .read(chatInputViewModelProvider.notifier)
            .updateLocation(event, screenSize);
      },
      child: CustomSendButton(messageController: messageController),
    );
  }
}
