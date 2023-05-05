import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_input/chat_input_field.dart';
import 'package:chat_app/features/home/presentation/widgets/chat_card.dart';

import 'package:chat_app/services/database_methods.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/sizes.dart';

import '../widgets/custom_appbar.dart';

class MessagesScreen extends HookConsumerWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // we will use getChatRoomMessages method to get the messages stream, this stream will user

    final usermodel = ref.watch(userProvider).userModel;

    final future = useMemoized(
        () => DatabaseMethods().getChatRoomMessages(ref.watch(chatroomId)));

    final messageSnapshot = useStream(useFuture(future).data);

    bool isWaiting =
        messageSnapshot.connectionState == ConnectionState.waiting ||
            !messageSnapshot.hasData;

    if (isWaiting) {
      return Scaffold(
        appBar: buildAppBar(usermodel),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: buildAppBar(usermodel),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: messageSnapshot.requireData.size,
                itemBuilder: (context, index) {
                  return const Text('Hello world');
                },
              ),
            ),
          ),
          const ChatInputField(),
        ],
      ),
    );
  }
}
