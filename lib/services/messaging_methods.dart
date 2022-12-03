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
  final lastMessageTs = DateTime.now();
  final chatterPfp = (FirebaseAuth.instance.currentUser?.photoURL)!;

  void addMessage(TextEditingController messageController) {
    String message = messageController.text;

    Map<String, dynamic> messageInfoMap = {
      "message": message,
      "imgUrl": chatterPfp,
      "sendBy": chatterUsername,
      "ts": lastMessageTs,
      "resUrl": '',
      "messageType": "text",
    };

    DatabaseMethods().addMessage(chatRoomId, messageId, messageInfoMap).then(
      (value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": chatterUsername,
        };
        // We update the user activity
        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);
        messageController.text = "";
      },
    );
  }

  sendVoiceMessage(WidgetRef ref) async {
    final path = await ref.read(recController.notifier).state.stop();
    if (path!.isEmpty) return;
    String audioUrl =
        await StorageMethods().uploadFileToStorage(path, messageId);

    Map<String, dynamic> messageInfoMap = {
      "message": '',
      "imgUrl": chatterPfp,
      "sendBy": chatterUsername,
      "ts": lastMessageTs,
      "resUrl": audioUrl,
      "messageType": "audio",
    };
    //messageId

    DatabaseMethods().addMessage(chatRoomId, messageId, messageInfoMap).then(
      (value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": 'Audio Message ',
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": chatterUsername,
        };
        // We update the user activity
        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);
      },
    );
  }

  sendMedia(List<File> imageFileList, TextEditingController messageController) async {
    final imageUrls = await Future.wait(imageFileList.map(
        (file) => StorageMethods().uploadFileToStorage(file.path, messageId)));
  }
}
