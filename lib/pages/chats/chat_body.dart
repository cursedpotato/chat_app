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
  final User? currentUser = FirebaseAuth.instance.currentUser;

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
            bool hasData = snapshot.hasData;
            if (hasData) {
              List documentSnapshot = snapshot.data!.docs;
              print(
                  "This is the length of the list ${documentSnapshot.length}");
              myUserName = currentUser!.displayName;
              return Expanded(
                child: ListView.builder(
                    itemCount: documentSnapshot.length,
                    itemBuilder: (BuildContext context, int index) => ChatCard()
                    ),
              );
            }
            return Text("ah fuck");
          },
        ),
      ],
    );
  }
}

class ChatCard extends StatefulWidget {
  const ChatCard({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  String profilePicUrl = "",
      name = "",
      username = "",
      lastMessage = "",
      date = "";
  // Future<QuerySnapshot> getThisUserInfo() async {
  //   username = widget.documentSnapshot.id
  //       .replaceAll(widget.myUsername, "")
  //       .replaceAll("_", "");
  //   return await DatabaseMethods().getUserInfo(username);
  // }

  // @override
  // void initState() {
  //   getThisUserInfo();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                    'https://masterclassenglish.com/wp-content/uploads/2019/05/noimage-placeholderpng.png',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
}
