import 'package:chat_app/core/utils/custom_typedefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageDatabaseServices {
  Future<FirebaseJsonStream> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }
}
