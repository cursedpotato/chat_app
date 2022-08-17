import 'package:cloud_firestore/cloud_firestore.dart';

class chatroomModel {
  String? lastMessage;
  String? lastMessageSendBy;
  Timestamp? lastMessageSendTs;
  List<String>? users;

  chatroomModel(
      {this.lastMessage,
      this.lastMessageSendBy,
      this.lastMessageSendTs,
      this.users});

  chatroomModel.fromJson(Map<String, dynamic> json) {
    lastMessage = json['lastMessage'];
    lastMessageSendBy = json['lastMessageSendBy'];
    lastMessageSendTs = json['lastMessageSendTs'];
    users = json['users'].cast<String>();
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
