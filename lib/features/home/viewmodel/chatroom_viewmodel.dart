import 'package:chat_app/core/routes/strings.dart';
import 'package:chat_app/core/utils/get_chatroom_id_util.dart';
import 'package:chat_app/features/home/models/chatroom_model.dart';
import 'package:chat_app/features/home/services/chatroom_database_services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'chattees_viewmodel.dart';

final chatRoomViewModel =
    StateNotifierProvider.autoDispose<ChatRoomViewModel, List<ChatroomModel>>(
  (ref) => ChatRoomViewModel(ref),
);

class ChatRoomViewModel extends StateNotifier<List<ChatroomModel>> {
  ChatRoomViewModel(this.ref) : super([]);

  final Ref ref;

  Future<void> createChatroom() async {
    final chatteeModel = ref.watch(chatteesViewModel).chattes[0];

    // create in the future a function that creates a chatroom with the current user and multiple chattees
    final chatroomId = getChatRoomIdByUsernames(chatteeModel.username);

    final chatroomInfoMap = ChatroomModel(
      id: chatroomId,
      lastMessage: '',
      lastMessageSendBy: '',
      lastMessageSendDate: '',
      chatroomImage: noImage,
      users: [chatterUsername!, chatteeModel.username],
    );

    await ChatroomDatabaseService.createChatRoom(
      chatroomId,
      chatroomInfoMap.toJson(),
    );
  }
}
