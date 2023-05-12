import 'package:chat_app/core/routes/strings.dart';
import 'package:chat_app/features/home/models/chatroom_model.dart';
import 'package:chat_app/features/home/services/chatroom_database_services.dart';
import 'package:chat_app/features/home/services/user_database_services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/chat_user_model.dart';
import 'chattees_viewmodel.dart';

final chatRoomViewModel =
    StateNotifierProvider<ChatRoomViewModel, List<ChatroomModel>>(
  (ref) => ChatRoomViewModel(ref),
);

class ChatRoomViewModel extends StateNotifier<List<ChatroomModel>> {
  final Ref ref;
  ChatRoomViewModel(this.ref) : super([]) {
    final sub = getChatroomStream().listen((model) async {
      await _addChatroom(model);
    });

    ref.onDispose(() => sub.cancel());
  }

  Future<void> _addChatroom(ChatroomModel? model) async {
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

          // We add the chatroom to the state
          state = [...state, completeModel];
        }
      }
    }
  }

  Future<void> createChatroom() async {
    List<ChatUserModel> chatteesList = ref.watch(chatteesViewModel).chattes;

    final chatroomId = const Uuid().v4();

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

  Stream<ChatroomModel?> getChatroomStream() async* {
    final stream = await ChatroomDatabaseService.getChatRooms();

    final snapshot = stream.asyncMap((event) {
      for (var element in event.docs) {
        if (element.data().isEmpty) {
          return null;
        }
        return ChatroomModel.fromJson(element.data());
      }
    });

    yield* snapshot;
  }
}
