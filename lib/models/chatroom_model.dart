import 'package:cloud_firestore/cloud_firestore.dart';

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
    lastMessage = document['lastMessage'];
    lastMessageSendBy = document['lastMessageSendBy'];
    lastMessageSendTs = document['lastMessageSendTs'];
    lastMessageSendDate = (document['lastMessageSendTs'] as Timestamp).toDate();
    users = document['users'].cast<String>();
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['lastMessage'] = this.lastMessage;
  //   data['lastMessageSendBy'] = this.lastMessageSendBy;
  //   data['lastMessageSendTs'] = this.lastMessageSendTs;
  //   data['users'] = this.users;
  //   return data;
  // }
}
