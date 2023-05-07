import 'dart:io';

import 'package:chat_app/features/chat/presentation/widgets/chat_input/recording_widget.dart';
import 'package:chat_app/features/chat/services/message_database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/routes/strings.dart';
import '../../home/services/database_methods.dart';
import 'message_storage_services.dart';

class MessagingMethods {
  MessagingMethods({required this.chatRoomId});

  String chatRoomId;
  final messageId = const Uuid().v1();
  final storageRef = FirebaseStorage.instance;

  Map<String, dynamic> messageInfoMap = {
    "message": "",
    "imgUrl": (FirebaseAuth.instance.currentUser?.photoURL)!,
    "sendBy": chatterUsername,
    "ts": DateTime.now(),
    "mediaList": [],
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

    MessageDatabaseService().addMessage(chatRoomId, messageId, messageInfoMap);
    MessageDatabaseService()
        .updateLastMessageSend(chatRoomId, lastMessageInfoMap);

    messageController.text = "";
  }

  sendVoiceMessage(WidgetRef ref) async {
    final path = await ref.read(recController.notifier).state.stop();
    if (path!.isEmpty) return;
    String audioUrl =
        await MessageStorageServices().uploadFileToStorage(path, messageId);

    messageInfoMap["messageType"] = "audio";
    // we send a list because that is the type we designed on our model to allow multiple media
    messageInfoMap["mediaList"] = FieldValue.arrayUnion([
      {
        'mediaType': 'image',
        'mediaUrl': audioUrl,
      }
    ]);
    lastMessageInfoMap["lastMessage"] = "Audio Message 🎧";
    storageRef.refFromURL(audioUrl).updateMetadata(SettableMetadata(
          contentType: "audio/m4a",
        ));

    MessageDatabaseService().addMessage(chatRoomId, messageId, messageInfoMap);
    MessageDatabaseService()
        .updateLastMessageSend(chatRoomId, lastMessageInfoMap);
  }

  sendMedia(
    List<File> imageFileList,
    TextEditingController messageController,
  ) async {
    messageInfoMap["message"] = messageController.text;
    messageInfoMap["messageType"] =
        imageFileList.length > 1 ? "gallery" : "media";
    messageInfoMap["mediaList"] = [];
    lastMessageInfoMap["lastMessage"] = "Media was shared 🖼️";

    await MessageDatabaseService()
        .addMessage(chatRoomId, messageId, messageInfoMap);
    await MessageDatabaseService()
        .updateLastMessageSend(chatRoomId, lastMessageInfoMap);
    // We upload video thumbnails if there's any

    for (File file in imageFileList) {
      final mediaUrl = await MessageStorageServices().uploadFileToStorage(
        file.path,
        messageId,
      );

      final isVideo = file.path.contains("mp4");

      final updateMap = {
        "mediaList": FieldValue.arrayUnion([
          {
            'mediaType': 'image',
            'mediaUrl': await MessageStorageServices().uploadFileToStorage(
              file.path,
              messageId,
            ),
          }
        ])
      };

      if (isVideo) {
        final thumbnailUrl = await MessageStorageServices()
            .uploadThumbnail(file, "${messageId}resindex=0");

        updateMap["mediaList"] = FieldValue.arrayUnion(
          [
            {
              'mediaType': 'video',
              'mediaUrl': mediaUrl,
              "thumbnailUrl": thumbnailUrl,
            }
          ],
        );
      }

      MessageDatabaseService().updateMessage(chatRoomId, messageId, updateMap);
    }
  }
}
