import 'package:chat_app/core/models/chat_user_model.dart';

class ChatroomModel {
  final String id;
  final String lastMessage;
  final String lastMessageSendBy;
  final String lastMessageSendDate;
  final String chatroomImage;
  final String chatroomName;
  final List<String> users;
  final List<ChatUserModel> usersInfo;

  ChatroomModel({
    required this.id,
    required this.lastMessage,
    required this.lastMessageSendBy,
    required this.lastMessageSendDate,
    required this.chatroomImage,
    required this.chatroomName,
    required this.users,
    this.usersInfo = const [],
  });

  // create copyWith method
  ChatroomModel copyWith({
    String? id,
    String? lastMessage,
    String? lastMessageSendBy,
    String? lastMessageSendDate,
    String? chatroomImage,
    String? chatroomName,
    List<String>? users,
    List<ChatUserModel>? usersInfo,
  }) {
    return ChatroomModel(
      id: id ?? this.id,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageSendBy: lastMessageSendBy ?? this.lastMessageSendBy,
      lastMessageSendDate: lastMessageSendDate ?? this.lastMessageSendDate,
      chatroomImage: chatroomImage ?? this.chatroomImage,
      chatroomName: chatroomName ?? this.chatroomName,
      users: users ?? this.users,
      usersInfo: usersInfo ?? this.usersInfo,
    );
  }

  // create toJson method
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "lastMessage": lastMessage,
      "lastMessageSendBy": lastMessageSendBy,
      "lastMessageSendDate": lastMessageSendDate,
      "chatroomImage": chatroomImage,
      "chatroomName": chatroomName,
      "users": users,
    };
  }

  // create fromJson method
  factory ChatroomModel.fromJson(Map<String, dynamic> json) {
    return ChatroomModel(
      id: json["id"],
      lastMessage: json["lastMessage"],
      lastMessageSendBy: json["lastMessageSendBy"],
      lastMessageSendDate: json["lastMessageSendDate"],
      chatroomImage: json["chatroomImage"],
      chatroomName: json["chatroomName"],
      users: List<String>.from(json["users"].map((x) => x)),
    );
  }
}
