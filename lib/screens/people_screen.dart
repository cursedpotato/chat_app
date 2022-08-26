import 'package:chat_app/globals.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PeopleScreen extends HookWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot>? userStream;

    final stream = useState(userStream);

    TextEditingController searchController = useTextEditingController();

    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 0.75),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
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
                  debugPrint(searchController.text);
                  DatabaseMethods()
                      .getUserByUserName(searchController.text)
                      .then(
                    (result) {
                      stream.value = result;
                    },
                  );
                },
                child: const Icon(
                  Icons.search,
                ),
              )
            ],
          ),
          StreamBuilder(
            stream: stream.value,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              bool isLoading =
                  snapshot.connectionState == ConnectionState.waiting;

              if (isLoading) {
                return const Text('Loading');
              }
              bool hasData = snapshot.hasData &
                  (snapshot.connectionState == ConnectionState.done);
              if (hasData) {
                List<DocumentSnapshot>? documentList = snapshot.data?.docs;
                return Expanded(
                  child: ListView.builder(
                    itemCount: documentList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      UserModel userModel =
                          UserModel.fromDocument(documentList[index]);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(userModel.pfpUrl!),
                          radius: 24,
                        ),
                        title: Text(userModel.name!),
                      );
                    },
                  ),
                );
              }
              return Text("There's no one to chat with");
            },
          ),
        ],
      ),
    );
  }
}
