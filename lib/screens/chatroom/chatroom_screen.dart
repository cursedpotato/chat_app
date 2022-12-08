import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/globals.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/screens/chatroom/chat_input/chat_input_field.dart';
import 'package:chat_app/screens/chatroom/message_types/media_message.dart';
import 'package:chat_app/screens/home/chat_card.dart';

import 'package:chat_app/services/database_methods.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/message_model.dart';

import 'message_types/audio_message_widget.dart';
import 'message_types/text_message_widget.dart';


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
                  ChatMesssageModel model = ChatMesssageModel.fromDocument(
                    messageSnapshot.requireData.docs[index],
                  );
                  return Message(message: model);
                },
              ),
            ),
          ),
          const ChatInputField(),
        ],
      ),
    );
  }

  AppBar buildAppBar(UserModel userModel) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: userModel.pfpUrl ?? noImage,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userModel.name!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Active ${userModel.dateToString()}",
                overflow: TextOverflow.visible,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.local_phone),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam),
          ),
        ],
      ),
    );
  }
}

class Message extends HookWidget {
  final ChatMesssageModel message;
  const Message({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget messageContent(ChatMesssageModel message) {
      final map = {
        ChatMessageType.text: TextMessage(message),
        ChatMessageType.audio: AudioMessage(message),
        ChatMessageType.gallery: MediaMessageWidget(message),
      };
      Widget type = map[message.messageType] ?? const SizedBox();
      return type;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
      child: Row(
        crossAxisAlignment: message.isSender!
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.center,
        mainAxisAlignment:
            message.isSender! ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender!) ...[
            Container(
              margin: const EdgeInsets.only(right: kDefaultPadding / 2),
              child: CircleAvatar(
                radius: 12,
                backgroundImage: CachedNetworkImageProvider(message.pfpUrl!),
              ),
            )
          ],
          messageContent(message),
          if (message.isSender!)
            MessageStatusDot(
              status: message.messageStatus!,
            ),
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus status;
  const MessageStatusDot({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      final map = {
        MessageStatus.notSent: kErrorColor,
        MessageStatus.notViewed:
            Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.1),
        MessageStatus.viewed: kPrimaryColor,
      };

      final result = map[status] ?? Colors.transparent;
      return result;
    }

    return Container(
      margin: const EdgeInsets.only(left: kDefaultPadding / 2, top: 18),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.notSent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
