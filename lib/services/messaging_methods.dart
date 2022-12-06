import 'dart:io';

import 'package:chat_app/screens/chatroom/chat_input/recording_widget.dart';
import 'package:chat_app/services/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../globals.dart';
import 'database_methods.dart';

class MessagingMethods {
  MessagingMethods({required this.chatRoomId});

  String chatRoomId;
  final messageId = const Uuid().v1();

  Map<String, dynamic> messageInfoMap = {
    "message": "",
    "imgUrl": (FirebaseAuth.instance.currentUser?.photoURL)!,
    "sendBy": chatterUsername,
    "ts": DateTime.now(),
    "resUrls": "",
    "messageType": "",
  };

  Map<String, dynamic> lastMessageInfoMap = {
    "lastMessage": "",
    "lastMessageSendTs": DateTime.now(),
    "lastMessageSendBy": chatterUsername,
  };

  void addMessage(TextEditingController messageController) {
    String message = messageController.text;

    messageInfoMap["message"] = message;
    messageInfoMap["messageType"] = "text";
    lastMessageInfoMap["lastMessage"] = message;

    DatabaseMethods().addMessage(chatRoomId, messageId, messageInfoMap);
    DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

    messageController.text = "";
  }

  sendVoiceMessage(WidgetRef ref) async {
    final path = await ref.read(recController.notifier).state.stop();
    if (path!.isEmpty) return;
    String audioUrl =
        await StorageMethods().uploadFileToStorage(path, messageId);

    messageInfoMap["messageType"] = "audio";
    // we send a list because that is the type we designed on our model to allow multiple media
    messageInfoMap["resUrls"] = [audioUrl];
    lastMessageInfoMap["lastMessage"] = "Audio Message 🎧";

    DatabaseMethods().addMessage(chatRoomId, messageId, messageInfoMap);
    DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);
  }

  sendMedia(
    List<File> imageFileList,
    TextEditingController messageController,
  ) async {
    // We upload all the files one by one
    await Future.wait(imageFileList.map(
      (file) => StorageMethods().uploadFileToStorage(file.path, messageId),
    )).then((imageUrls) {
      String message = messageController.text;

      messageInfoMap["message"] = message;
      messageInfoMap["messageType"] = "gallery";
      messageInfoMap["resUrls"] = imageUrls;
      lastMessageInfoMap["lastMessage"] = "Audio Message 🎧";

      DatabaseMethods().addMessage(chatRoomId, messageId, messageInfoMap);
      DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);
    });
  }
}
