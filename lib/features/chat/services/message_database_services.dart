import 'package:chat_app/features/chat/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/custom_typedefs.dart';

class MessageDatabaseService {
  static Future<FirebaseJsonStream> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  static Future<void> addMessage(
    String chatRoomId,
    ChatMessageModel message,
  ) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(message.id)
        .set(message.toJson());
  }

  Future<void> updateMessage(
    String chatRoomId,
    ChatMessageModel message,
  ) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(message.id)
        .update(message.toJson());
  }
}
