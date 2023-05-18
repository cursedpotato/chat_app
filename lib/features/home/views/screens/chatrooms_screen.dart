import 'dart:developer';

import 'package:chat_app/features/home/viewmodel/chatroom_viewmodel.dart';
import 'package:chat_app/features/home/views/widgets/chat_card.dart';
import 'package:chat_app/features/home/views/widgets/filledout_button.dart';
import 'package:chat_app/features/home/views/widgets/home_screen_widgets/home_screen_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/sizes.dart';
import '../../models/chatroom_model.dart';

final chatroomStream = StreamProvider.autoDispose<ChatroomModel?>(
  (ref) => ref.watch(chatRoomViewModel.notifier).getChatroomStream(),
);

class ChatroomScreen extends HookConsumerWidget {
  const ChatroomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useFocusNode().unfocus();

    return Scaffold(
      appBar: homeAppbar(context),
      body: Column(
        children: const [
          _ActivityRow(),
          _MainList(),
        ],
      ),
    );
  }
}

class _MainList extends ConsumerWidget {
  const _MainList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatroomStreamData = ref.watch(chatroomStream);
    final chatroomList = ref.watch(chatRoomViewModel);

    return chatroomStreamData.when(
      data: (_) {
        if (chatroomList.isEmpty) {
          return const Text('no chatrooms');
        }
        return Expanded(
          child: ListView.builder(
            itemCount: chatroomList.length,
            itemBuilder: (_, int index) => ChatCard(
              chatroomModel: chatroomList[index],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        log(error.toString());
        return const Text('error');
      },
      loading: () {
        return const Text('loading');
      },
    );
  }
}

class _ActivityRow extends HookWidget {
  const _ActivityRow();

  @override
  Widget build(BuildContext context) {
    final isActive = useState(false);
    return Flexible(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          kDefaultPadding,
          0,
          kDefaultPadding,
          kDefaultPadding,
        ),
        color: Theme.of(context).primaryColor,
        child: Row(
          children: [
            FillOutlineButton(
              press: () => isActive.value = !isActive.value,
              text: "Recent Messages",
              isFilled: !isActive.value,
            ),
            const SizedBox(width: kDefaultPadding),
            FillOutlineButton(
              press: () => isActive.value = !isActive.value,
              text: "Active",
              isFilled: isActive.value,
            ),
          ],
        ),
      ),
    );
  }
}
