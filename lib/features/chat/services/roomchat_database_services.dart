import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/routes/strings.dart';

class RoomChatDatabaseService {
  static updateLastMessageSend(
    String chatRoomId,
    String lastMessage,
  ) {
    Map<String, dynamic> lastMessageInfoMap = {
      "lastMessage": lastMessage,
      "lastMessageSendTs": DateTime.now(),
      "lastMessageSendBy": chatterUsername,
    };
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }
}
