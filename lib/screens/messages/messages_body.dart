// ignore_for_file: constant_identifier_names

import 'package:chat_app/globals.dart';
import 'package:chat_app/modelview/message_model.dart';
import 'package:chat_app/screens/messages/chat_input_field.dart';
import 'package:chat_app/screens/messages/text_message.dart';
import 'package:chat_app/screens/messages/video_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../services/database.dart';
import 'audio_message.dart';
import 'dot_indicator.dart';

List demeChatMessages = [
  ChatMessage(
    text: "Hi Sajol,",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
  ChatMessage(
    text: "Hello, How are you?",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: true,
  ),
  ChatMessage(
    text: "",
    messageType: ChatMessageType.audio,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
  ChatMessage(
    text: "",
    messageType: ChatMessageType.video,
    messageStatus: MessageStatus.viewed,
    isSender: true,
  ),
  ChatMessage(
    text: "Error happend",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.notSent,
    isSender: true,
  ),
  ChatMessage(
    text: "This looks great man!!",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
  ChatMessage(
    text: "Glad you like it",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.notViewed,
    isSender: true,
  ),
];

class Body extends HookWidget {
  final List<QueryDocumentSnapshot> querySnapshot;
  // TODO: eliminate this middleman with provider
  final String chatteName;
  const Body({
    Key? key,
    required this.querySnapshot,
    required this.chatteName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: ListView.builder(
              itemCount: demeChatMessages.length,
              itemBuilder: (BuildContext context, int index) {
                var blahblah = querySnapshot[index].data();
                print("This is the data I need ya donke $blahblah");
                return Message(
                  chatteeName: chatteName,
                  message: demeChatMessages[index],
                );
              },
            ),
          ),
        ),
        const ChatInputField()
      ],
    );
  }
}

class Message extends HookWidget {
  final ChatMessage message;
  final String chatteeName;
  const Message({
    Key? key,
    required this.message,
    required this.chatteeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget messageContent(ChatMessage message) {
      switch (message.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message);
        case ChatMessageType.audio:
          return AudioMessage(message: message);
        case ChatMessageType.video:
          return const VideoWidget();
        default:
          return const SizedBox();
      }
    }

    final chatteFuture =
        useMemoized(() => DatabaseMethods().getUserInfo(chatteeName));

    QuerySnapshot? chatteData = useFuture(chatteFuture).data;

    String? chattePfp = chatteData?.docs[0]["imgUrl"];
    String noUser =
        "https://hope.be/wp-content/uploads/2015/05/no-user-image.gif";

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            Container(
              margin:
                  const EdgeInsets.only(right: kDefaultPadding / 2, top: 20),
              child: CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage(chattePfp ?? noUser),
              ),
            )
          ],
          messageContent(message),
          if (message.isSender)
            MessageStatusDot(
              status: message.messageStatus,
            ),
        ],
      ),
    );
  }
}
