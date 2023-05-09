import 'package:chat_app/features/home/models/chattee_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/models/chat_user_model.dart';

final chatteesViewModel =
    StateNotifierProvider<ChatteesViewModel, ChattesModel>(
  (ref) => ChatteesViewModel(),
);

class ChatteesViewModel extends StateNotifier<ChattesModel> {
  ChatteesViewModel()
      : super(
          const ChattesModel(
            chattes: [],
          ),
        );

  void addChattee(ChatUserModel chattee) {
    state = state.copyWith(chattes: [...state.chattes, chattee]);
  }
}
