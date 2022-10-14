import 'package:chat_app/globals.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/chatroom/messages_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'chatroom/messages_screen.dart';

class PeopleScreen extends HookWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<List<QuerySnapshot<Object?>>>? getFutures;

    // This value notifier is used to update the state of the stream builder
    ValueNotifier getQueries = useState(getFutures);

    TextEditingController searchController = useTextEditingController();

    late final animationController =
        useAnimationController(duration: const Duration(milliseconds: 500));
    late final Animation<Offset> animationOffset = Tween<Offset>(
      begin: const Offset(0.0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.bounceInOut),
    );

    animationController.forward();

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
        child: Column(
          children: [
            SlideTransition(
              position: animationOffset,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
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
                            hintText: "Search a friend",
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      debugPrint("Click");
                      var usernameQuery = DatabaseMethods()
                          .getUserByUserName(searchController.text);
                      var nameQuery = DatabaseMethods()
                          .getUserByName(searchController.text);
                      getQueries.value =
                          Future.wait([usernameQuery, nameQuery]);
                      searchController.text = "";
                    },
                    child: const Icon(
                      Icons.search,
                    ),
                  )
                ],
              ),
            ),
            FutureBuilder<List<QuerySnapshot<Object?>>>(
              future: getQueries.value,
              builder: (BuildContext context,
                  AsyncSnapshot<List<QuerySnapshot>> snapshot) {
                if (!snapshot.hasData) {
                  return const Text("");
                }
                bool isLoading =
                    snapshot.connectionState == ConnectionState.waiting;
                if (isLoading) {
                  return const Text('Loading');
                }
      
                bool? query1HasData = snapshot.data?[0].docs.isNotEmpty;
                if (query1HasData!) {
                  List<DocumentSnapshot>? documentList = snapshot.data?[0].docs;
                  return userList(documentList);
                }
      
                bool? query2HasData = snapshot.data?[1].docs.isNotEmpty;
                if (query2HasData!) {
                  List<DocumentSnapshot>? documentList = snapshot.data?[1].docs;
                  return userList(documentList);
                }
      
                return const Text("There's no one to chat with");
              },
            )
          ],
        ),
      ),
    );
  }

  Widget userList(List<DocumentSnapshot>? documentList) {
    return Expanded(
      child: ListView.builder(
        itemCount: documentList!.length,
        itemBuilder: (BuildContext context, int index) {
          UserModel userModel = UserModel.fromDocument(documentList[index]);
          return userTile(userModel, context);
        },
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
