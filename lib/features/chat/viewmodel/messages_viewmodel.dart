import 'dart:io';

import 'package:chat_app/features/chat/services/message_database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../home/views/widgets/chat_card.dart';
import '../models/media_model.dart';
import '../models/message_model.dart';
import '../services/roomchat_database_services.dart';
import '../utils/file_upload_utils.dart';

final messagesVMProvider = StateNotifierProvider.autoDispose<MessagesViewModel,
    List<ChatMessageModel>>(
  (ref) => MessagesViewModel(ref),
);

class MessagesViewModel extends StateNotifier<List<ChatMessageModel>> {
  final Ref ref;
  ScrollController scrollController = ScrollController();

  MessagesViewModel(this.ref) : super([]);

  Stream<List<ChatMessageModel>> getMessages() async* {
    final idChatroom = ref.watch(chatroomId);
    final stream = await MessageDatabaseService.getMessages(idChatroom);

    yield* stream.map((snapshot) {
      _addMessages(snapshot);
      return state;
    });
  }

  Future<void> uploadMessage(ChatMessageModel message) async {
    final idChatroom = ref.watch(chatroomId);
    _addMessageToList(message);

    scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );

    // uplaod message to firebase
    final status = await MessageDatabaseService.addMessage(idChatroom, message);
    // update message status
    if (status.isRight()) {
      _updateMessageStatus(message, MessageStatus.sent);
      MessageDatabaseService.updateMessage(
        idChatroom,
        message.copyWith(messageStatus: MessageStatus.sent),
      );
      // update last message sent
      await RoomChatDatabaseService.updateLastMessageSend(
        idChatroom,
        message.message,
      );
    } else {
      _updateMessageStatus(message, MessageStatus.error);
    }
  }

  void sendMediaMessage(
    BuildContext context,
    List<File> fileList,
    String text,
  ) async {
    Navigator.of(context).pop();

    final idChatroom = ref.read(chatroomId);
    final messageId = const Uuid().v4();

    for (File file in fileList) {
      final media = await mediaTypeToModel(
        fileMediaType(file),
        file,
        idChatroom,
      );

      final message = ChatMessageModel.mediaMessage(
        id: messageId,
        message: text,
        mediaList: [media],
      );

      final isFirst = file.path == fileList.first.path;
      if (isFirst) {
        uploadMessage(message);
      }

      if (!isFirst) {
        MessageDatabaseService.updateMediaMessageList(
          messageId,
          idChatroom,
          media,
        );
      }
    }
  }

  void _addMessages(QuerySnapshot snapshot) {
    List<ChatMessageModel> messages = [];
    for (final message in snapshot.docs) {
      messages.add(ChatMessageModel.fromDocument(message));
    }

    state = [...messages];
  }

  void _addMessageToList(ChatMessageModel message) {
    for (var message in state) {
      if (state.contains(message)) {
        return;
      }

      state = [...state, message];
    }
  }

  void _updateMessageStatus(
    ChatMessageModel message,
    MessageStatus messageStatus,
  ) {
    state = [
      for (message in state)
        if (message.id == message.id)
          message.copyWith(
            messageStatus: messageStatus,
          )
        else
          message
    ];
  }
}
