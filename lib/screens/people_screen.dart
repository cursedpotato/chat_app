import 'package:chat_app/globals.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PeopleScreen extends HookWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot>? userStream;

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
                  var future = useMemoized(() => DatabaseMethods()
                      .getUserByUserName(searchController.text));
                  userStream = useFuture(future).data;
                },
                child: const Icon(
                  Icons.search,
                ),
              )
            ],
          ),
          StreamBuilder(
            stream: userStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Container();
                  },
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
