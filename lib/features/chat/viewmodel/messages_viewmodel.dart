import 'package:chat_app/features/chat/services/message_database_services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../home/views/widgets/chat_card.dart';
import '../models/message_model.dart';
import '../services/roomchat_database_services.dart';

final messagesViewModelProvider =
    StateNotifierProvider<MessagesViewModel, List<ChatMessageModel>>(
  (ref) => MessagesViewModel(ref),
);

class MessagesViewModel extends StateNotifier<List<ChatMessageModel>> {
  final Ref ref;

  MessagesViewModel(this.ref) : super([]) {
    getMessages().listen((event) {
      state = [...state, event];
    });
  }

  Stream<ChatMessageModel> getMessages() async* {
    final idChatroom = ref.watch(chatroomId);
    final stream = await MessageDatabaseService.getChatRoomMessages(idChatroom);

    await for (var snapshot in stream) {
      for (var element in snapshot.docs) {
        final message = ChatMessageModel.fromDocument(element);
        yield message;
      }
    }
  }

  Future<void> addMessage(ChatMessageModel message) async {
    final idChatroom = ref.watch(chatroomId);
    state = [...state, message];
    // uplaod message to firebase
    final status = await MessageDatabaseService.addMessage(idChatroom, message);
    // update message status
    if (status.isRight()) {
      _updateMessageStatus(message, MessageStatus.sent);
      // update last message sent
      await RoomChatDatabaseService.updateLastMessageSend(
        idChatroom,
        message.message,
      );
    } else {
      _updateMessageStatus(message, MessageStatus.error);
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
