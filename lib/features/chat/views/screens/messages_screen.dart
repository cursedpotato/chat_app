import 'package:chat_app/features/chat/viewmodel/messages_viewmodel.dart';
import 'package:chat_app/features/chat/views/widgets/chat_input/chat_input_field.dart';

import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../home/viewmodel/chattees_viewmodel.dart';
import '../../models/message_model.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/message/message_widget.dart';

final messagesStreamProvider =
    StreamProvider.autoDispose<List<ChatMessageModel>>(
  (ref) => ref.watch(messagesViewModelProvider.notifier).getMessages(),
);

class MessagesScreen extends HookConsumerWidget {
  static const routeName = 'chat/messages';
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesStream = ref.watch(messagesStreamProvider);

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
              child: messagesStream.when(
                data: (messages) => const MessageList(),
                error: (error, stackTrace) {
                  return const Center(
                    child: Text("Error"),
                  );
                },
                loading: () => const CircularProgressIndicator(),
              ),
            ),
            const ChatInputField(),
          ],
        ),
      ),
    );
  }
}

class MessageList extends HookConsumerWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController =
        ref.watch(messagesViewModelProvider.notifier).scrollController;
    final messages = ref.watch(messagesViewModelProvider);
    return ListView.builder(
      controller: scrollController,
      itemCount: messages.length,
      reverse: true,
      itemBuilder: (context, index) => Message(
        message: messages[index],
      ),
    );
  }
}
