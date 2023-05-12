import 'package:chat_app/features/chat/services/message_database_services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/routes/strings.dart';
import '../../home/views/widgets/chat_card.dart';
import '../models/message_model.dart';

class MessagesViewModel extends StateNotifier<List<ChatMessageModel>> {
  WidgetRef ref;

  MessagesViewModel(this.ref) : super([]);

  Map<String, dynamic> lastMessageInfoMap = {
    "lastMessage": "",
    "lastMessageSendTs": DateTime.now(),
    "lastMessageSendBy": chatterUsername,
  };

  void addMessage(ChatMessageModel message) async {
    final idChatroom = ref.watch(chatroomId);
    state = [...state, message];
    // uplaod message to firebase
    await MessageDatabaseService.addMessage(idChatroom, message);
    // update message status
    state = [
      for (message in state)
        if (message.id == message.id)
          message.copyWith(
            messageStatus: MessageStatus.sent,
          )
        else
          message
    ];
    // update last message sent
  }
}
