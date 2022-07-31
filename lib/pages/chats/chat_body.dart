import 'package:chat_app/globals.dart';
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
  String? myUserName;
  Stream<QuerySnapshot>? chatRoomsStream;

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
                press: () {},
                text: "Resent Messages",
              ),
              const SizedBox(width: kDefaultPadding),
              FillOutlineButton(
                press: () {},
                text: "Active",
                isFilled: false,
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
              List<DocumentSnapshot> documentSnapshot = snapshot.data!.docs;
              return Expanded(
                child: ListView.builder(
                    itemCount: documentSnapshot.length,
                    itemBuilder: (BuildContext context, int index) => ChatCard(
                          documentSnapshot: documentSnapshot,
                        )),
              );
            }
            return const Text("ah fuck");
          },
        ),
      ],
    );
  }
}

class ChatCard extends StatefulWidget {
  final List<DocumentSnapshot> documentSnapshot;
  const ChatCard({
    Key? key,
    required this.documentSnapshot,
  }) : super(key: key);

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final String? myUsername =
      FirebaseAuth.instance.currentUser?.email!.replaceAll("@gmail.com", "");

  String profilePicUrl = "",
      name = "",
      username = "",
      lastMessage = "",
      date = "";
  Future<QuerySnapshot> getThisUserInfo() async {
    username = widget.documentSnapshot[0].id
        .replaceAll(myUsername!, "")
        .replaceAll("_", "");
    print('this is the username: $username');
    return await DatabaseMethods().getUserInfo(username);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getThisUserInfo(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        bool hasData = snapshot.hasData;
        if (hasData) {
          print("This is the data: ${snapshot.data!.docs[0]["imgUrl"]}");
          profilePicUrl = snapshot.data!.docs[0]["imgUrl"];
          name = snapshot.data!.docs[0]["name"];
          username = snapshot.data!.docs[0]['username'];

          return GestureDetector(
            onTap: () {},
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
                        backgroundImage: NetworkImage(
                          profilePicUrl 
                        ),
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
                              color: Theme.of(context).scaffoldBackgroundColor,
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
        return LinearProgressIndicator();
      },
    );
  }
}
