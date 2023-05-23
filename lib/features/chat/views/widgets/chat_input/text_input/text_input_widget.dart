import 'package:chat_app/core/theme/sizes.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/theme/colors.dart';

class ChatRoomTextField extends HookConsumerWidget {
  const ChatRoomTextField({
    Key? key,
    required this.messageController,
  }) : super(key: key);

  final TextEditingController messageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Everytime the user writes we want to switch between the mic and the send button

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
            hintText: "Aa",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
