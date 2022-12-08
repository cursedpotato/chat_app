
import 'package:chat_app/models/custom_getters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../globals.dart';

enum ChatMessageType { text, audio, gallery, video }

enum MessageStatus { notSent, notViewed, viewed }

ChatMessageType whatType(String documentType) {
  const map = {
    'text': ChatMessageType.text,
    'audio': ChatMessageType.audio,
    'gallery': ChatMessageType.gallery,
    'video': ChatMessageType.video
  };
  ChatMessageType type = map[documentType] ?? ChatMessageType.text;

  return type;
}

MessageStatus messageStatus(String documentType) {
  const map = {
    'not-send': MessageStatus.notSent,
    'not_viewed': MessageStatus.notViewed,
    'viewed': MessageStatus.viewed,
  };

  MessageStatus status = map[documentType] ?? MessageStatus.notSent;

  return status;
}

class ChatMesssageModel {
  String? id;
  String? message;
  ChatMessageType? messageType;
  MessageStatus? messageStatus;
  bool? isSender;
  List<String>? resUrls;
  String? pfpUrl;
  String? sendBy;
  Timestamp? timestamp;

  ChatMesssageModel({
    this.id,
    this.message,
    this.messageType,
    this.messageStatus,
    this.isSender,
    this.resUrls,
    this.pfpUrl,
    this.sendBy,
    this.timestamp,
  });

  ChatMesssageModel.fromDocument(DocumentSnapshot document) {
    id = document.id;
    message = document.getString('message');
    messageType = whatType(document.getString('messageType'));
    // TODO: Find a way to show a message status
    messageStatus = MessageStatus.viewed;
    isSender = chatterUsername == document['sendBy'];
    resUrls = document.getList('resUrls');
    pfpUrl = document.getString('imgUrl');
    sendBy = document.getString('sendBy');
    timestamp = document.getTimeStamp('ts');
  }
}
