import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearching = false;

  Stream<QuerySnapshot>? usersStream;

  TextEditingController searchUsername = TextEditingController();

  onSearch() async {
    isSearching = true;
    usersStream =
        await DatabaseMethods().getUserByUsername(searchUsername.text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Capybara chat"),
          actions: [
            // May change to icon button
            InkWell(
              onTap: () {
                AuthMethods().signOut().then((_) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const SignIn()));
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.exit_to_app),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [_searchEraseBtn(), _searchBar()],
            ),
            isSearching ? _searchUsersList() : _chatRoomList()
          ],
        ));
  }

  Widget _searchEraseBtn() {
    return isSearching
        ? Container(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                isSearching = false;
                searchUsername.text = "";
                setState(() {});
              },
              child: const Icon(Icons.arrow_back),
            ),
          )
        : Container();
  }

  Widget _searchBar() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(24)),
        child: TextField(
          controller: searchUsername,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "username",
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  if (searchUsername.text != "") {
                    onSearch();
                  }
                });
              },
              child: const Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchUsersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: usersStream,
      builder: (_, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs   ,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Image.network(
                    ds["imgUrl"],
                    height: 30,
                    width: 30,
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget _chatRoomList() {
    return Container();
  }
}
