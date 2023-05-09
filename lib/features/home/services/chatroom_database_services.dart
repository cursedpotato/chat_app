import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/routes/strings.dart';

class ChatroomDatabaseService {
  static createChatRoom(
    String chatroomId,
    Map<String, dynamic> chatroomInfoMap,
  ) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroomId)
          .set(chatroomInfoMap);
    }
  }

  static Future<Stream<QuerySnapshot>> getChatRooms() async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastMessageSendTs", descending: true)
        .where("users", arrayContains: chatterUsername)
        .snapshots();
  }
}
