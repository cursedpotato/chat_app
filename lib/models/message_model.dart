import 'package:chat_app/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class ChatMesssageModel {
  String? message;
  ChatMessageType? messageType;
  MessageStatus? messageStatus;
  bool? isSender;
  String? resUrl;
  String? pfpUrl;
  String? sendBy;
  Timestamp? timestamp;

  ChatMesssageModel({
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
   
    message = document['message'] ?? '';
    messageType = whatType(document['messageType']);
    // TODO: Find a way to show a message status
    messageStatus = MessageStatus.viewed;
    isSender = chatterUsername == document['sendBy'];
    resUrl = document['resUrl'];
    pfpUrl = document['imgUrl'] ?? "";
    sendBy = document['sendBy'] ?? "";
    timestamp = document['ts'] ?? "";
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['text'] = this.text;
  //   data['messageType'] = this.messageType;
  //   data['messageStatus'] = this.messageStatus;
  //   data['isSender'] = this.isSender;
  //   data['pfpUrl'] = this.pfpUrl;
  //   data['sendBy'] = this.sendBy;
  //   data['timestamp'] = this.timestamp;
  //   return data;
  // }
}
