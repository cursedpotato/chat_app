import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum ChatMessageType { text, audio, image, video }

enum MessageStatus { notSent, notViewed, viewed }

ChatMessageType whatType(DocumentSnapshot documentSnapshot) {
  if (documentSnapshot["type"] == "text") {
    return ChatMessageType.text;
  }
  if (documentSnapshot["type"] == "audio") {
    return ChatMessageType.audio;
  }
  if (documentSnapshot["type"] == "video") {
    return ChatMessageType.video;
  }
  if (documentSnapshot["type"] == "image") {
    return ChatMessageType.image;
  }
  if (documentSnapshot["type"] == null) {
    return ChatMessageType.text;
  }
  return ChatMessageType.text;
}

class ChatMesssageModel {
  String? message;
  ChatMessageType? messageType;
  MessageStatus? messageStatus;
  bool? isSender;
  String? pfpUrl;
  String? sendBy;
  Timestamp? timestamp;

  ChatMesssageModel({
    this.message,
    this.messageType,
    this.messageStatus,
    this.isSender,
    this.pfpUrl,
    this.sendBy,
    this.timestamp,
  });

  ChatMesssageModel.fromDocument(DocumentSnapshot document) {
    String? myUsername =
        FirebaseAuth.instance.currentUser?.email?.replaceAll("@gmail.com", "");
    message = document['message'];
    messageType = whatType(document['type']);
    // messageStatus = document['messageStatus'];
    messageStatus = MessageStatus.viewed;
    isSender = myUsername == document['sendBy'];
    pfpUrl = document['pfpUrl'];
    sendBy = document['sendBy'];
    timestamp = document['timestamp'];
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

class ChatMessage {
  final String message;
  final ChatMessageType messageType;
  final MessageStatus messageStatus;
  // username is same as firebase auth current user
  final bool isSender;

  ChatMessage({
    this.message = '',
    required this.messageType,
    required this.messageStatus,
    required this.isSender,
  });
}
