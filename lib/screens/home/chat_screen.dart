import 'package:chat_app/globals.dart';
import 'package:chat_app/screens/calls_screen.dart';
import 'package:chat_app/screens/home/chat_body.dart';
import 'package:chat_app/screens/people_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomeScreen extends HookWidget {
  
  final List<Widget> screenList = const [
    Body(),
    CallScreen(),
    PeopleScreen(),
    ProfileScreen(),
  ];

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? profilePicUrl = FirebaseAuth.instance.currentUser?.photoURL;
    final selectedIndex = useState(0);
    return Scaffold(
      appBar: buildAppBar(),
      body: screenList[selectedIndex.value],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.person_add_alt_1),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex.value,
        onTap: (int index) => selectedIndex.value = index,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.message), label: "Message"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.people), label: "People"),
          const BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
          BottomNavigationBarItem(
              icon: CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(profilePicUrl!),
              ),
              label: "Profile")
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: const Text("Chats"),
      
    );
  }
}
