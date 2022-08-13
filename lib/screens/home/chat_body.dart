import 'package:chat_app/globals.dart';
import 'package:chat_app/screens/messages/messages.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/filledout_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Stream<QuerySnapshot>? chatRoomsStream;

  // This variable was created to filter chatroom stream data and toggle buttons
  bool isActive = false;

  getChatRooms() async {
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  @override
  void initState() {
    getChatRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
            kDefaultPadding,
            0,
            kDefaultPadding,
            kDefaultPadding,
          ),
          color: kPrimaryColor,
          child: Row(
            children: [
              FillOutlineButton(
                press: () => setState(() {
                  isActive = !isActive;
                }),
                text: "Recent Messages",
                isFilled: !isActive,
              ),
              const SizedBox(width: kDefaultPadding),
              FillOutlineButton(
                press: () => setState(() {
                  isActive = !isActive;
                }),
                text: "Active",
                isFilled: isActive,
              ),
            ],
          ),
        ),
        StreamBuilder(
          stream: chatRoomsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            bool isWaiting =
                snapshot.connectionState == ConnectionState.waiting;
            if (isWaiting) {
              return const LinearProgressIndicator();
            }
            bool hasData = snapshot.hasData;
            if (hasData) {
              // TODO: Add conditional that filters if users are active or nots
              List<DocumentSnapshot> documentList = snapshot.data!.docs;
              return Expanded(
                child: ListView.builder(
                  itemCount: documentList.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot documentSnapshot = documentList[index];

                    return ChatCard(
                      documentSnapshot: documentSnapshot,
                    );
                  },
                ),
              );
            }
            // TODO: Make an error screen
            return const Text("Something went wrong");
          },
        ),
      ],
    );
  }
}

class ChatCard extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const ChatCard({
    Key? key,
    required this.documentSnapshot,
  }) : super(key: key);

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  // This variables are used on the future builder to fill data into the card itself
  String profilePicUrl = "",
      name = "",
      username = "",
      lastMessage = "",
      date = "";

  /* This variable is used to exclude the chatter name from a document id 
  (the chat document id is formed as a combination between the chatte and chatter username) 
  to get the chatte name and fetch the chatte info from a method
  */
  final String? chatterUsername =
      FirebaseAuth.instance.currentUser?.email!.replaceAll("@gmail.com", "");

  Future<QuerySnapshot> getThisUserInfo() async {
    username = widget.documentSnapshot.id
        .replaceAll(chatterUsername!, "")
        .replaceAll("_", "");
    return await DatabaseMethods().getUserInfo(username);
  }

  /* The idea of this variable was to check if the chatte is active but
  I don't have a clear idea of how to implement it yet, I might create a provider  */
  // DateTime fiveMinAgo = DateTime.now().subtract(const Duration(minutes: 5));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getThisUserInfo(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          bool hasData = snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done;
          if (hasData) {
            profilePicUrl = snapshot.data!.docs[0]["imgUrl"];
            name = snapshot.data!.docs[0]["name"];
            username = snapshot.data!.docs[0]['username'];
            lastMessage = widget.documentSnapshot["lastMessage"];
            DateTime dt =
                (widget.documentSnapshot['lastMessageSendTs'] as Timestamp)
                    .toDate();
            date = timeago.format(dt);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessagesScreen(
                      chatterName: chatterUsername!,
                      chatteeName: username,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding * 0.75),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(profilePicUrl),
                        ),
                        // TODO: add conditional to check if user is active

                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            Opacity(
                              opacity: 0.64,
                              child: Text(
                                lastMessage,
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
                      child: Text(date),
                    )
                  ],
                ),
              ),
            );
          }

          return const LinearProgressIndicator();
        });
  }
}
