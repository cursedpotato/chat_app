import 'package:chat_app/globals.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/messages/messages_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PeopleScreen extends HookWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future? getFutures;

    ValueNotifier getQueries = useValueNotifier(getFutures);

    // This value notifier is used to update the state of the stream builder
    TextEditingController searchController = useTextEditingController();
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 0.75),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: searchController,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        hintText: "Search a friend", border: InputBorder.none),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  var usernameQuery = DatabaseMethods()
                      .getUserByUserName(searchController.text);
                  var nameQuery =
                      DatabaseMethods().getUserByName(searchController.text);

                  getQueries.value = Future.wait([usernameQuery, nameQuery])
                      .then((value) => print(value));
                },
                child: const Icon(
                  Icons.search,
                ),
              )
            ],
          ),
          FutureBuilder(
            future: getQueries.value,
            builder: (BuildContext context,
                AsyncSnapshot<List<QuerySnapshot>> snapshot) {
              bool isLoading =
                  snapshot.connectionState == ConnectionState.waiting;
              if (isLoading) {
                return const Text('Loading');
              }
              // ignore: prefer_is_empty
              bool query1HasData = snapshot.data?[0].docs.length != 0;
              // ignore: prefer_is_empty
              bool query2HasData = snapshot.data?[1].docs.length != 0;
              if (snapshot.hasData && query1HasData) {
                List<DocumentSnapshot>? documentList = snapshot.data?[0].docs;
                return Expanded(
                  child: ListView.builder(
                    itemCount: documentList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      UserModel userModel =
                          UserModel.fromDocument(documentList[index]);
                      return userTile(userModel, context);
                    },
                  ),
                );
              }
              if (snapshot.hasData && query2HasData) {
                List<DocumentSnapshot>? documentList = snapshot.data?[0].docs;
                return Expanded(
                  child: ListView.builder(
                    itemCount: documentList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      UserModel userModel =
                          UserModel.fromDocument(documentList[index]);
                      return userTile(userModel, context);
                    },
                  ),
                );
              }

              return const Text("There's no one to chat with");
            },
          )

          // FutureBuilder(
          //   future: ,
          //   builder:
          //       (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //     bool isLoading =
          //         snapshot.connectionState == ConnectionState.waiting;

          //     if (isLoading) {
          //       return const Text('Loading');
          //     }
          //     bool hasData = snapshot.hasData;
          //     if (hasData) {
          //       List<DocumentSnapshot>? documentList = snapshot.data?.docs;
          //       return Expanded(
          //         child: ListView.builder(
          //           itemCount: documentList!.length,
          //           itemBuilder: (BuildContext context, int index) {
          //             UserModel userModel =
          //                 UserModel.fromDocument(documentList[index]);
          //             return userTile(userModel, context);
          //           },
          //         ),
          //       );
          //     }
          //     // This could create the method to call itself so find a better logic

          //     return const Text("There's no one to chat with");
          //   },
          // ),
        ],
      ),
    );
  }

  Widget userTile(UserModel userModel, BuildContext context) {
    return ListTile(
      onTap: () => createChat(context, userModel),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userModel.pfpUrl!),
        radius: 24,
      ),
      title: Text(userModel.name!),
    );
  }

  void createChat(BuildContext context, UserModel userModel) {
    var chatRoomId =
        getChatRoomIdByUsernames(chatterUsername!, userModel.username!);
    Map<String, dynamic> chatRoomInfoMap = {
      "users": [chatterUsername, userModel.username]
    };
    DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagesScreen(
            chatterName: chatterUsername!,
            chatteeName: userModel.username!,
            lastSeen: ""),
      ),
    );
  }
}
