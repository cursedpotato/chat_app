class ChatroomModel {
  final String id;
  final String lastMessage;
  final String lastMessageSendBy;
  final String lastMessageSendDate;
  final String chatroomImage;
  final List<String> users;

  ChatroomModel({
    required this.id,
    required this.lastMessage,
    required this.lastMessageSendBy,
    required this.lastMessageSendDate,
    required this.chatroomImage,
    required this.users,
  });

  // create toJson method
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "lastMessage": lastMessage,
      "lastMessageSendBy": lastMessageSendBy,
      "lastMessageSendDate": lastMessageSendDate,
      "chatroomImage": chatroomImage,
      "users": users,
    };
  }

  // create fromJson method
  ChatroomModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        lastMessage = json['lastMessage'],
        lastMessageSendBy = json['lastMessageSendBy'],
        lastMessageSendDate = json['lastMessageSendDate'],
        chatroomImage = json['chatroomImage'],
        users = List<String>.from(json['users']);
}
