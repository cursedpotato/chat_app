import 'package:chat_app/core/routes/strings.dart';
import 'package:chat_app/features/home/models/chatroom_model.dart';
import 'package:chat_app/features/home/services/chatroom_database_services.dart';
import 'package:chat_app/features/home/services/user_database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/models/chat_user_model.dart';
import 'chattees_viewmodel.dart';

final chatRoomViewModel =
    StateNotifierProvider<ChatRoomViewModel, List<ChatroomModel>>(
  (ref) => ChatRoomViewModel(ref),
);

class ChatRoomViewModel extends StateNotifier<List<ChatroomModel>> {
  final Ref ref;
  ChatRoomViewModel(this.ref) : super([]);

  Future<ChatroomModel?> _addChatroom(ChatroomModel? model) async {
    if (model != null) {
      // We remove the chatter from the users list
      // because we only need the chattee info
      model.users.removeWhere((element) => element == chatterUsername!);

      // We iterate over the users list to get the chattee info
      for (var user in model.users) {
        // We get the chattee info
        final userFuture = await getChatteInfo(user);
        // We iterate over future docs and finally we transform the data
        // into a ChatUserModel
        for (var element in userFuture.docs) {
          final chatteInfo = ChatUserModel.fromJson(
            (element.data() as Map<String, dynamic>),
          );
          // We create a new model with the chattee info
          final completeModel = model.copyWith(
            chatroomImage: chatteInfo.profilePic,
            usersInfo: [...model.usersInfo, chatteInfo],
          );

          return completeModel;
        }
      }
    }

    return null;
  }

  Future<void> createChatroom(String chatroomId) async {
    List<ChatUserModel> chatteesList = ref.watch(chatteesViewModel).chattes;

    final chatroomInfoMap = ChatroomModel(
      id: chatroomId,
      lastMessage: '',
      lastMessageSendBy: '',
      lastMessageSendDate: '',
      chatroomImage: chatteesList.first.profilePic,
      chatroomName: chatteesList.first.name,
      users: [
        chatterUsername!,
        ...chatteesList.map((e) => e.username).toList(),
      ],
    );

    await ChatroomDatabaseService.createChatRoom(
      chatroomId,
      chatroomInfoMap.toJson(),
    );
  }

  Stream<List<ChatroomModel>> getChatroomStream() async* {
    final stream = await ChatroomDatabaseService.getChatRooms();

    yield* stream.asyncMap((snapshot) => _addChatrooms(snapshot));
  }

  Future<List<ChatroomModel>> _addChatrooms(QuerySnapshot snapshot) async {
    List<ChatroomModel> chatrooms = [];
    for (final chatroom in snapshot.docs) {
      final model = ChatroomModel.fromDocument(chatroom);
      final completeModel = await _addChatroom(model);
      if (completeModel != null) {
        chatrooms.add(completeModel);
      }
    }

    return state = chatrooms;
  }
}
