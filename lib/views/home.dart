import 'package:chat_app/helperfunctions/sharedpreferences_helper.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chat_screen.dart';
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

  String? myName, myProfilePic, myUserName, myEmail;

  @override
  void initState() {
    super.initState();
    getInfoFromSharePreference();
  }

  onSearch() async {
    isSearching = true;
    usersStream =
        await DatabaseMethods().getUserByUsername(searchUsername.text);
    setState(() {});
  }

  getInfoFromSharePreference() async {
    myName = await SharedPreferencesHelper().getDisplayName();
    myProfilePic = await SharedPreferencesHelper().getUserProfile();
    myUserName = await SharedPreferencesHelper().getUserName();
    myEmail = await SharedPreferencesHelper().getUserEmail();

    
  }
  
  String getChatRoomId(String? a, String? b) {
    if (a!.substring(0, 1).codeUnitAt(0) > b!.substring(0, 1).codeUnitAt(0)) {
      // ignore: unnecessary_string_escapes
      return "$b\_$a";
    } else {
      // ignore: unnecessary_string_escapes
      return "$a\_$b";
    }
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

  Widget _userTile(DocumentSnapshot ds) {
    
    String name = ds["name"];
    String username = ds["username"];
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Image.network(
          ds["imgUrl"],
          height: 30,
          width: 30,
        ),
      ),
      title: Text(name),
      subtitle: Text(username),
      onTap: () {
        
        var chatRoomId = getChatRoomId(myName, name);
        Map<String, dynamic> chatRoomInfoMap = {
          "users" : [myName, name],
        };
        Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(chatwithUsername: username, name: name,)));      
      },
    );
  }

  Widget _searchUsersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: usersStream,
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.size,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return _userTile(ds);
              });
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _chatRoomList() {
    return Container();
  }
}
