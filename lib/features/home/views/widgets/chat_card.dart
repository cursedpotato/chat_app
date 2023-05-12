import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/utils/chatroom_image_util.dart';

import 'package:chat_app/features/home/models/chatroom_model.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../../chat/views/screens/messages_screen.dart';
import '../../viewmodel/chattees_viewmodel.dart';

final chatroomId = StateProvider<String>((ref) => '');
final chatroomImage = StateProvider<String>((ref) => '');

class ChatCard extends HookConsumerWidget {
  const ChatCard({
    Key? key,
    required this.chatroomModel,
  }) : super(key: key);

  final ChatroomModel chatroomModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = chatroomModel.usersInfo;

    return ListTile(
      onTap: () {
        for (var user in userInfo) {
          ref.read(chatteesViewModel.notifier).addChattee(user);
        }
        ref.read(chatroomId.notifier).state = chatroomModel.id;
        ref.read(chatroomId.notifier).state = chatroomModel.chatroomImage;

        Navigator.pushNamed(context, MessagesScreen.routeName);
      },
      leading: _Leading(chatroomModel: chatroomModel),
      title: _Title(chatroomModel: chatroomModel),
      subtitle: _Subtitle(chatroomModel: chatroomModel),
      trailing: _Trailing(chatroomModel: chatroomModel),
    );
  }
}

class _Leading extends StatelessWidget {
  const _Leading({
    required this.chatroomModel,
  });

  final ChatroomModel chatroomModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: CachedNetworkImageProvider(
            chatroomImageUtil(chatroomModel),
          ),
        ),
        const _ActivityDot()
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.chatroomModel,
  });

  final ChatroomModel chatroomModel;

  @override
  Widget build(BuildContext context) {
    return Text(
      chatroomModel.chatroomName,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({
    required this.chatroomModel,
  });

  final ChatroomModel chatroomModel;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.64,
      child: Text(
        chatroomModel.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({
    required this.chatroomModel,
  });

  final ChatroomModel chatroomModel;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.64,
      child: Text(
        chatroomModel.lastMessageSendDate,
      ),
    );
  }
}

class _ActivityDot extends StatelessWidget {
  const _ActivityDot();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
