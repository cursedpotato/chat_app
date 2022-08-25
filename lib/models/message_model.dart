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
    // messageType = whatType(document['type']);
    // TODO: add message type to firebase
    messageType = ChatMessageType.text;
    // TODO: Find a way to show a message status
    messageStatus = MessageStatus.viewed;
    isSender = myUsername == document['sendBy'];
    pfpUrl = document['imgUrl'];
    sendBy = document['sendBy'];
    timestamp = document['ts'];
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
