import 'package:chat_app/models/custom_getters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:timeago/timeago.dart' as timeago;

class ChatroomModel {
  String? id;
  String? lastMessage;
  String? lastMessageSendBy;
  Timestamp? lastMessageSendTs;
  DateTime? lastMessageSendDate;
  List<String>? users;

  String dateToString() {
    final format = timeago.format(lastMessageSendDate!);
    return format;
  }

  ChatroomModel({
    this.id,
    this.lastMessage,
    this.lastMessageSendBy,
    this.lastMessageSendTs,
    this.lastMessageSendDate,
    this.users,
  });

  ChatroomModel.fromDocument(DocumentSnapshot document) {
    id = document.id;
    lastMessage = document.getString('lastMessage');
    lastMessageSendBy = document.getString('lastMessageSendBy');
    lastMessageSendTs = document.getTimeStamp('lastMessageSendTs');
    lastMessageSendDate = document.getDateFromTs('lastMessageSendTs');
    users = document['users'].cast<String>();
  }
}
