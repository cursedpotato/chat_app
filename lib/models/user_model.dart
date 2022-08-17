import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserModel {
  String? pfpUrl;
  String? name;
  String? email;
  String? username;
  Timestamp? userActivityTs;
  DateTime? lastSeenDate;

  UserModel({
    this.pfpUrl,
    this.name,
    this.email,
    this.username,
    this.userActivityTs,
    this.lastSeenDate,
  });

  UserModel.fromDocument(DocumentSnapshot documentSnapshot) {
    pfpUrl = documentSnapshot['imgUrl'];
    name = documentSnapshot['name'];
    email = documentSnapshot['email'];
    username = documentSnapshot['username'];
    userActivityTs = documentSnapshot['userActivityTs'];
    lastSeenDate = (documentSnapshot['userActivityTs'] as Timestamp).toDate();
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['pfpUrl'] = this.pfpUrl;
  //   data['name'] = this.name;
  //   data['email'] = this.email;
  //   data['username'] = this.username;
  //   data['userActivityTs'] = this.userActivityTs;
  //   return data;
  // }
}
