import 'package:chat_app/features/chat/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class MessageDatabaseService {
  static Future<Stream<QuerySnapshot<Map<String, dynamic>>>>
      getChatRoomMessages(chatRoomId) async {
    final db = FirebaseFirestore.instance;
    db.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: 10000000,
    );
    return db
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots(includeMetadataChanges: true);
  }

  static Future<Either<Exception, Unit>> addMessage(
    String chatRoomId,
    ChatMessageModel message,
  ) async {
    final map = message.toJson();
    try {
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .collection("chats")
          .doc(message.id)
          .set(map);
      return right(unit);
    } on Exception catch (e) {
      return left(e);
    }
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
