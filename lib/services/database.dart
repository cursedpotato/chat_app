import 'dart:typed_data';

import 'package:chat_app/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class DatabaseMethods {

  updateUserTs() {
    // We need the userId to access the document
    final userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({"userActivityTs": DateTime.now()});
  }

  Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
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

  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  uploadFile() {
    
  }

  // Future<String> uploadImage(FilePickerResult result) async {
  //   String id = const Uuid().v1();
  //   String fileName = result.files.first.name;
  //   Uint8List? fileBytes = result.files.first.bytes;
  //   Reference ref =
  //       FirebaseStorage.instance.ref('images/$fileName').child(id);
    
  //   // putting in uint8list format -> Upload task like a future but not future
  //   UploadTask uploadTask = ref.putData(fileBytes!);

  //   TaskSnapshot snapshot = await uploadTask;
  //   String downloadUrl = await snapshot.ref.getDownloadURL();
  //   return downloadUrl;
  // }

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

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
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
