import 'package:chat_app/globals.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/filledout_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../helperfunctions/sharedpref_helper.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isSearching = false;
  String? myName, myProfilePic, myUserName, myEmail;
  Stream<QuerySnapshot>? usersStream, chatRoomsStream;

  TextEditingController searchUsernameEditingController =
      TextEditingController();

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      // ignore: unnecessary_string_escapes
      return "$b\_$a";
    } else {
      // ignore: unnecessary_string_escapes
      return "$a\_$b";
    }
  }

  getChatRooms() async {
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  onScreenLoaded() async {
    await getMyInfoFromSharedPreference();
    getChatRooms();
  }

  @override
  void initState() {
    onScreenLoaded();
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
        StreamBuilder<QuerySnapshot>(
          stream: chatRoomsStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            bool isLoading =
                snapshot.connectionState == ConnectionState.waiting;
            if (isLoading) {
              return const Text("loading...");
            }
            bool isError = snapshot.connectionState == ConnectionState.none;
            if (isError) {
              return const Text("ERROR");
            }
            bool hasData = snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData ||
                snapshot.connectionState == ConnectionState.active;
            if (hasData) {
              return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) => ChatCard(
                          documentSnapshot: snapshot.data!.docs[index],
                          myUsername: myUserName!,
                        )),
              );
            }
            return const Text("Something is wrong");
          },
        ),
      ],
    );
  }
}

class ChatCard extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final String myUsername;
  const ChatCard({
    Key? key,
    required this.documentSnapshot,
    required this.myUsername,
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
  Future<QuerySnapshot> getThisUserInfo() async {
    username = widget.documentSnapshot.id
        .replaceAll(widget.myUsername, "")
        .replaceAll("_", "");
    return await DatabaseMethods().getUserInfo(username);
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timestamp? timeOflastM;
    return FutureBuilder(
      future: getThisUserInfo(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        name = snapshot.data!.docs[0]["name"];
        profilePicUrl = snapshot.data!.docs[0]["imgUrl"];
        lastMessage = widget.documentSnapshot["lastMessage"];
        timeOflastM = widget.documentSnapshot["lastMessageSendTs"];
        date = timeago.format(
          timeOflastM!.toDate(),
        );
        bool hasData = snapshot.hasData;
        if (hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
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
                              color: Theme.of(context).scaffoldBackgroundColor,
                            )),
                      ),
                    )
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
          );
        }
        return const LinearProgressIndicator();
      },
    );
  }
}
