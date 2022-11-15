import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/globals.dart';
import 'package:chat_app/screens/chatroom/chat_input/chat_input_field.dart';

import 'package:chat_app/services/database_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../models/message_model.dart';

import 'message_types/audio_message_widget.dart';
import 'message_types/text_message_widget.dart';
import 'message_types/video_widget.dart';

class MessagesScreen extends HookWidget {
  final String chatteeName;
  final String lastSeen;
  const MessagesScreen({
    Key? key,
    required this.chatteeName,
    required this.lastSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // we will use getChatRoomMessages method to get the messages stream, this stream will user

    final chatroomId = getChatRoomIdByUsernames(chatteeName, chatterUsername!);

    final future =
        useMemoized(() => DatabaseMethods().getChatRoomMessages(chatroomId));

    final messageSnapshot = useStream(useFuture(future).data);

    bool isWaiting =
        messageSnapshot.connectionState == ConnectionState.waiting ||
            !messageSnapshot.hasData;

    if (isWaiting) {
      return Scaffold(
        appBar: buildAppBar(),
        body: const Center(child:  CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: buildAppBar(),
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
                  return Message(
                    chatteeName: chatteeName,
                    message: model,
                  );
                },
              ),
            ),
          ),
          ChatInputField(chatteeName: chatteeName),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    final chatteFuture =
        useMemoized(() => DatabaseMethods().getUserInfo(chatteeName));

    QuerySnapshot? chatteData = useFuture(chatteFuture).data;

    String? chattePfp = chatteData?.docs[0]["imgUrl"];

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: chattePfp ?? noImage,
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
                chatteeName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Active $lastSeen",
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
  final String chatteeName;
  const Message({
    Key? key,
    required this.message,
    required this.chatteeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget messageContent(ChatMesssageModel message) {
      final map = {
        ChatMessageType.text: TextMessage(message: message),
        ChatMessageType.audio: AudioMessage(message: message),
        ChatMessageType.video: const VideoWidget(),
      };
      Widget type = map[message.messageType] ?? const SizedBox();
      return type;
    }

    // final chatteFuture =
    //     useMemoized(() => DatabaseMethods().getUserInfo(chatteeName));

    // QuerySnapshot? chatteData = useFuture(chatteFuture).data;

    String? chattePfp = noImage;

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
                backgroundImage: CachedNetworkImageProvider(chattePfp),
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
    Color? dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.notSent:
          return kErrorColor;
        case MessageStatus.notViewed:
          return Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.1);
        case MessageStatus.viewed:
          return kPrimaryColor;
        default:
          return Colors.transparent;
      }
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
