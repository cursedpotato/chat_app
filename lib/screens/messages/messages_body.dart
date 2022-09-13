import 'package:chat_app/globals.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/screens/messages/chat_input_field.dart';
import 'package:chat_app/screens/messages/text_message.dart';
import 'package:chat_app/screens/messages/video_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../services/database.dart';
import 'audio_message.dart';
import 'dot_indicator.dart';

class Body extends HookWidget {
  final List<QueryDocumentSnapshot> querySnapshot;
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
          flex: 5,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: querySnapshot.length,
                itemBuilder: (BuildContext context, int index) {
                  ChatMesssageModel model =
                      ChatMesssageModel.fromDocument(querySnapshot[index]);
                  return Message(
                    chatteeName: chatteName,
                    message: model,
                  );
                },
              ),
            ),
          ),
        ),
        ChatInputField(chatteeName: chatteName,),
      ],
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
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4 ),
      child: Row(
        crossAxisAlignment: message.isSender! ? CrossAxisAlignment.end : CrossAxisAlignment.center,
        mainAxisAlignment:
            message.isSender! ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender!) ...[
            Container(
              margin:
                  const EdgeInsets.only(right: kDefaultPadding / 2),
              child: CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage(chattePfp ?? noUser),
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
