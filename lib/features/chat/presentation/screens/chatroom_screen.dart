import 'package:chat_app/features/chat/models/message_model.dart';
import 'package:chat_app/features/chat/presentation/widgets/message/message_widget.dart';
import 'package:chat_app/features/chat/services/chatroom_database_services.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_input/chat_input_field.dart';
import 'package:chat_app/features/home/presentation/widgets/chat_card.dart';

import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/custom_appbar.dart';

class MessagesScreen extends HookConsumerWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
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
    );
  }
}
