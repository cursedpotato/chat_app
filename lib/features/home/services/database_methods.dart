import 'package:chat_app/core/routes/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  updateUserTs() {
    // We need the userId to access the document
    final userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({"userActivityTs": DateTime.now()});
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserByName(
      String query) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: query)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserByUserName(
      String query) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: query)
        .get();
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastMessageSendTs", descending: true)
        .where("users", arrayContains: chatterUsername)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }
}
