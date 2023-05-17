import 'package:chat_app/features/chat/views/widgets/chat_input/chat_input_field.dart';

import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../home/viewmodel/chattees_viewmodel.dart';
import '../widgets/custom_appbar.dart';

class MessagesScreen extends HookConsumerWidget {
  static const routeName = 'chat/messages';
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: buildChatroomAppbar(ref),
      body: WillPopScope(
        onWillPop: () async {
          ref.read(chatteesViewModel.notifier).removeAllChattees();
          return true;
        },
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return const SizedBox();
                },
              ),
            ),
            const ChatInputField(),
          ],
        ),
      ),
    );
  }
}
