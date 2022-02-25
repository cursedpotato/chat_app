import 'package:chat_app/helperfunctions/sharedpreferences_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserInfoTodb(
      String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getUserByUsername(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
  }

  Future addMessage(String chatroomId, String messageId,
      Map<String, dynamic> messageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfo) {
    Future.delayed(const Duration(milliseconds: 100), () async {
      final snapShot = await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .get();
      if (snapShot.exists) {
        return FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(chatRoomId)
            .update(lastMessageInfo);
      }
    });
  }

  createChatRoom(String chatRoomId, Map<String, dynamic> chatRoomInfo) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfo);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String myName = SharedPreferencesHelper.userNameKey;
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastMessageSendTs", descending: true)
        .where("users", arrayContains: myName)
        .snapshots();
  }

  getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }
}
