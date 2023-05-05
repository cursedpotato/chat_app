import 'package:chat_app/core/utils/custom_getters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/routes/strings.dart';
import '../utils/media_list_from_document.dart';
import '../utils/message_models_enum_functions.dart';
import 'media_model.dart';

enum ChatMessageType { text, audio, gallery, video }

enum MessageStatus { notSent, notViewed, viewed }

class ChatMesssageModel {
  late final String id;
  late final String message;
  late final ChatMessageType messageType;
  late final MessageStatus messageStatus;
  late final bool isSender;
  late final String pfpUrl;
  late final String sendBy;
  late final Timestamp timestamp;
  late final List<Media> mediaList;

  ChatMesssageModel({
    required this.id,
    required this.message,
    required this.messageType,
    required this.messageStatus,
    required this.isSender,
    required this.pfpUrl,
    required this.sendBy,
    required this.timestamp,
    required this.mediaList,
  });

  ChatMesssageModel.fromDocument(DocumentSnapshot document) {
    id = document.id;
    message = document.getString('message');
    messageType = whatMessageType(document.getString('messageType'));
    messageStatus = MessageStatus.viewed;
    isSender = chatterUsername == document['sendBy'];
    pfpUrl = document.getString('imgUrl');
    sendBy = document.getString('sendBy');
    timestamp = document.getTimeStamp('ts');
    mediaList = mediaListFromDocument(document);
  }
}