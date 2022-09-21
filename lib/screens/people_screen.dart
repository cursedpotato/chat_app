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
    Future<QuerySnapshot>? userFuture;

    // This value notifier is used to update the state of the stream builder
    ValueNotifier future = useState(userFuture);

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
                  future.value = DatabaseMethods()
                      .getUserByUserName(searchController.text);
                },
                child: const Icon(
                  Icons.search,
                ),
              )
            ],
          ),
          FutureBuilder(
            future: future.value,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              bool isLoading =
                  snapshot.connectionState == ConnectionState.waiting;

              if (isLoading) {
                return const Text('Loading');
              }
              bool hasData = snapshot.hasData;
              if (hasData) {
                List<DocumentSnapshot>? documentList = snapshot.data?.docs;
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
              // This could create the method to call itself so find a better logic
              // if (!hasData) {
              //   DatabaseMethods()
              //         .getUserByName(searchController.text)
              //         .then((result) => stream.value = result);
              // }
              return const Text("There's no one to chat with");
            },
          ),
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
