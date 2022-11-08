import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/globals.dart';

class ChatroomModel {
  String? lastMessage;
  String? lastMessageSendBy;
  Timestamp? lastMessageSendTs;
  DateTime? lastMessageSendDate;
  List<String>? users;

  ChatroomModel(
      {this.lastMessage,
      this.lastMessageSendBy,
      this.lastMessageSendTs,
      this.lastMessageSendDate,
      this.users});

  ChatroomModel.fromDocument(DocumentSnapshot document) {
    lastMessage = document.getString('lastMessage');
    lastMessageSendBy = document.getString('lastMessageSendBy');
    lastMessageSendTs = document.getTimeStamp('lastMessageSendTs');
    lastMessageSendDate = document.getDateFromTs('lastMessageSendTs');
    users = document['users'].cast<String>();
  }
}
