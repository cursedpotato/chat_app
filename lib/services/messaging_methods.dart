import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/screens/chatroom/chat_input/recording_widget.dart';
import 'package:chat_app/services/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../globals.dart';
import 'database_methods.dart';

class MessagingMethods {
  void addMessage(
    TextEditingController messageController,
    String chatteeUsername,
  ) {
    String messageId = "";
    if (messageController.text.isEmpty) return;

    String message = messageController.text;
    String? chatterPfp = FirebaseAuth.instance.currentUser?.photoURL;
    String chatRoomId =
        getChatRoomIdByUsernames(chatteeUsername, chatterUsername!);
    var lastMessageTs = DateTime.now();

    Map<String, dynamic> messageInfoMap = {
      "message": message,
      "imgUrl": chatterPfp,
      "sendBy": chatterUsername,
      "ts": lastMessageTs,
      "resUrl": '',
      "messageType": "text",
    };

    //messageId
    if (messageId == "") {
      messageId = const Uuid().v1();
    }

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
        messageId = "";
      },
    );
  }

  sendVoiceMessage(WidgetRef ref) async {
      String? chatteeUsername = ref.watch(userProvider).userModel.username;
      String messageId = "";
      if (messageId == "") {
        messageId = const Uuid().v1();
      }
      final path = await ref.read(recController.notifier).state.stop();
      if (path!.isEmpty) return;
      String audioUrl =
          await StorageMethods().uploadFileToStorage(path, messageId);

      String? chatterPfp = FirebaseAuth.instance.currentUser?.photoURL;
      String chatRoomId =
          getChatRoomIdByUsernames(chatteeUsername!, chatterUsername!);
      var lastMessageTs = DateTime.now();

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
          DatabaseMethods()
              .updateLastMessageSend(chatRoomId, lastMessageInfoMap);
          messageId = "";
        },
      );
    }
}
