import 'package:chat_app/models/chatroom_model.dart';
import 'package:chat_app/screens/chatroom/messages_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../globals.dart';
import '../../models/user_model.dart';
import '../../services/database.dart';

class ChatCard extends StatelessWidget {
  final bool showOnlyActive;
  final DocumentSnapshot chatroomDocument;
  const ChatCard({
    Key? key,
    required this.showOnlyActive,
    required this.chatroomDocument,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* This variable is used to exclude the chatter name from a document id 
    (the chat document id is formed as a combination between the chatte and chatter username) 
    to get the chatte name and fetch the chatte info from a method
    */
    String? chatterUsername =
        FirebaseAuth.instance.currentUser?.email!.replaceAll("@gmail.com", "");

    Future<QuerySnapshot> getThisUserInfo() async {
      final username = chatroomDocument.id
          .replaceAll(chatterUsername!, "")
          .replaceAll("_", "");
      return await DatabaseMethods().getUserInfo(username);
    }

    return FutureBuilder(
      future: getThisUserInfo(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        bool hasData = snapshot.hasData;
        if (hasData) {
          UserModel userModel = UserModel.fromDocument(snapshot.data!.docs[0]);
          ChatroomModel chatroomModel =
              ChatroomModel.fromDocument(chatroomDocument);
          return listTile(context, userModel, chatroomModel);
        }

        return const LinearProgressIndicator();
      },
    );
  }

  Widget listTile(
    BuildContext context,
    UserModel userModel,
    ChatroomModel chatroomModel,
  ) {
    DateTime fiveMinAgo = DateTime.now().subtract(const Duration(minutes: 5));
    String lastMessage = timeago.format(chatroomModel.lastMessageSendDate!);
    String lastSeen = timeago.format(userModel.lastSeenDate!);
    bool isActive = userModel.lastSeenDate!.isAfter(fiveMinAgo);
    // We added this var because !showOnlyActive does not work well on isOnlyActive
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
                  backgroundImage: NetworkImage(userModel.pfpUrl!),
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
