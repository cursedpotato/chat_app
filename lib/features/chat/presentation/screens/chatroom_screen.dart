import 'package:chat_app/features/chat/models/message_model.dart';
import 'package:chat_app/features/chat/presentation/widgets/message/message_widget.dart';
import 'package:chat_app/features/chat/services/chatroom_database_services.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_input/chat_input_field.dart';
import 'package:chat_app/features/home/presentation/widgets/chat_card.dart';

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

    final future = useMemoized(() =>
        ChatroomDatabaseServices().getChatRoomMessages(ref.watch(chatroomId)));

    final messageSnapshot = useStream(useFuture(future).data);

    bool isWaiting =
        messageSnapshot.connectionState == ConnectionState.waiting ||
            !messageSnapshot.hasData;

    if (isWaiting) {
      return Scaffold(
        appBar: buildAppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemCount: messageSnapshot.requireData.size,
              itemBuilder: (context, index) {
                final message = messageSnapshot.requireData.docs[index];
                final model = ChatMesssageModel.fromDocument(message);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                  ),
                  child: Message(message: model),
                );
              },
            ),
          ),
          const ChatInputField(),
        ],
      ),
    );
  }
}
