import 'package:chat_app/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


enum ChatMessageType { text, audio, image, video }

enum MessageStatus { notSent, notViewed, viewed }

ChatMessageType whatType(String documentType) {
  const map = {
    'text': ChatMessageType.text,
    'audio': ChatMessageType.audio,
    'image': ChatMessageType.image,
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

  MessageStatus type = map[documentType] ?? MessageStatus.notSent;

  return type;
}

class ChatMesssageModel {
  String? id;
  String? message;
  ChatMessageType? messageType;
  MessageStatus? messageStatus;
  bool? isSender;
  String? resUrl;
  String? pfpUrl;
  String? sendBy;
  Timestamp? timestamp;

  ChatMesssageModel({
    this.id,
    this.message,
    this.messageType,
    this.messageStatus,
    this.isSender,
    this.resUrl,
    this.pfpUrl,
    this.sendBy,
    this.timestamp,
  });

  ChatMesssageModel.fromDocument(DocumentSnapshot document) {
    id = document.id;
    message = document.getString('message');
    messageType = whatType(document['messageType']);
    // TODO: Find a way to show a message status
    messageStatus = MessageStatus.viewed;
    isSender = chatterUsername == document['sendBy'];
    resUrl = document.getString('resUrl');
    pfpUrl = document.getString('imgUrl');
    sendBy = document.getString('sendBy');
    timestamp = document.getTimeStamp('ts');
  }
}
