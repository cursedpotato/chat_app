import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/message_model.dart';

class MessagesViewModel extends StateNotifier<List<ChatMesssageModel>> {
  MessagesViewModel() : super([]);

  void addMessage(ChatMesssageModel message) {
    state = [...state, message];

    // uplaod message to firebase

    // update message status
  }
}
