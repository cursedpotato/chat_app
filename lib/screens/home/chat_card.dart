import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chatroom_model.dart';
import 'package:chat_app/screens/chatroom/chatroom_screen.dart';
import 'package:chat_app/screens/home/home_screen.dart';
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
    final userReference = ref.read(userModelProvider.notifier);
    /* This variable is used to exclude the chatter name from a document id 
    (the chat document id is formed as a combination between the chatte and chatter username) 
    to get the chatte name and fetch the chatte info from a method
    */
    Future<QuerySnapshot> getThisUserInfo() async {
      final username = chatroomDocument.id
          .replaceAll(chatterUsername!, "")
          .replaceAll("_", "");
      return await DatabaseMethods().getUserInfo(username);
    }

    final userdata = useFuture(getThisUserInfo());

    final isConnectionDone = userdata.connectionState == ConnectionState.done;
    if (userdata.hasData && isConnectionDone) {
      UserModel userModel = UserModel.fromDocument(userdata.data!.docs[0]);
      userReference.state = userModel;
    }

    return FutureBuilder(
      future: getThisUserInfo(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        bool hasData = snapshot.hasData;
        if (hasData) {
          UserModel userModel = UserModel.fromDocument(snapshot.data!.docs[0]);
          ChatroomModel chatroomModel =
              ChatroomModel.fromDocument(chatroomDocument);
          return ListTile(
            userModel: userModel,
            chatroomModel: chatroomModel,
            showOnlyActive: showOnlyActive,
          );
        }

        return const LinearProgressIndicator();
      },
    );
  }
}

class ListTile extends ConsumerWidget {
  const ListTile({
    Key? key,
    required this.userModel,
    required this.chatroomModel,
    required this.showOnlyActive,
  }) : super(key: key);
  final UserModel userModel;
  final ChatroomModel chatroomModel;
  final bool showOnlyActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime fiveMinAgo = DateTime.now().subtract(const Duration(minutes: 5));
    String lastMessage = timeago.format(chatroomModel.lastMessageSendDate!);
    bool isActive = userModel.lastSeenDate!.isAfter(fiveMinAgo);
    bool notActive = !showOnlyActive;
    bool isOnlyActive = ((showOnlyActive && isActive) || notActive);

    if (!isOnlyActive) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MessagesScreen(),
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
