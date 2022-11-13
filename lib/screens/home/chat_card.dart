import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chatroom_model.dart';
import 'package:chat_app/screens/chatroom/chatroom_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../globals.dart';
import '../../models/user_model.dart';
import '../../services/database_methods.dart';

class ChatCard extends HookConsumerWidget {
  final bool showOnlyActive;
  final DocumentSnapshot chatroomDocument;
  const ChatCard({
    Key? key,
    required this.showOnlyActive,
    required this.chatroomDocument,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    

    Future<QuerySnapshot> getThisUserInfo() async {
      final username = chatroomDocument.id
          .replaceAll(chatterUsername!, "")
          .replaceAll("_", "");
      return await DatabaseMethods().getUserInfo(username);
    }

    final userFuture = useFuture(getThisUserInfo());
    final isDone = userFuture.connectionState == ConnectionState.done;

    if (!userFuture.hasData && !isDone) return const SizedBox();

    UserModel userModel = UserModel.fromDocument(userFuture.data!.docs[0]);
    ChatroomModel chatroomModel = ChatroomModel.fromDocument(chatroomDocument);
    DateTime fiveMinAgo = DateTime.now().subtract(const Duration(minutes: 5));
    String lastMessage = timeago.format(chatroomModel.lastMessageSendDate!);
    String lastSeen = timeago.format(userModel.lastSeenDate!);
    bool isActive = userModel.lastSeenDate!.isAfter(fiveMinAgo);
    bool isOnlyActive = ((showOnlyActive && isActive) || (!showOnlyActive));
    if (!isOnlyActive) return const SizedBox();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagesScreen(
              chatterName: chatterUsername!,
              chatteeName: userModel.username!,
              lastSeen: lastSeen,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      CachedNetworkImageProvider(userModel.pfpUrl!),
                ),
                isActive ? activityDot(context) : const SizedBox(),
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userModel.name!,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        chatroomModel.lastMessage!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(lastMessage),
            )
          ],
        ),
      ),
    );
  }

  Positioned activityDot(BuildContext context) {
      return Positioned(
        right: 0,
        bottom: 0,
        child: Container(
          height: 16,
          width: 16,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
      );
    }
}
