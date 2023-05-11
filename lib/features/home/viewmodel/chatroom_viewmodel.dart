import 'package:chat_app/core/routes/strings.dart';
import 'package:chat_app/core/utils/get_chatroom_id_util.dart';
import 'package:chat_app/features/home/models/chatroom_model.dart';
import 'package:chat_app/features/home/services/chatroom_database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'chattees_viewmodel.dart';

final chatRoomViewModel =
    StateNotifierProvider.autoDispose<ChatRoomViewModel, List<ChatroomModel>>(
  (ref) => ChatRoomViewModel(ref),
);

class ChatRoomViewModel extends StateNotifier<List<ChatroomModel>> {
  ChatRoomViewModel(this.ref) : super([]) {
    final sub = getChatroomStream().listen((event) {
      if (event != null) {
        state = [...state, event];
      }
    });

    ref.onDispose(() => sub.cancel());
  }

  final Ref ref;

  Future<void> createChatroom() async {
    final db = FirebaseFirestore.instance;
    final chatteeModel = ref.watch(chatteesViewModel).chattes[0];

    // create in the future a function that creates a chatroom with the current user and multiple chattees
    final chatroomId = getChatRoomIdByUsernames(chatteeModel.username);

    final chatterDocRef = db.collection("users").doc(chatterUsername);
    final chatteeDocRef = db.collection("users").doc(chatteeModel.username);

    final chatroomInfoMap = ChatroomModel(
      id: chatroomId,
      lastMessage: '',
      lastMessageSendBy: '',
      lastMessageSendDate: '',
      chatroomImage: noImage,
      users: [chatteeDocRef, chatterDocRef],
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
