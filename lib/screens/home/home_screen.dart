import 'package:chat_app/globals.dart';
import 'package:chat_app/screens/calls_screen.dart';
import 'package:chat_app/screens/home/home_body.dart';
import 'package:chat_app/screens/people_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/screens/signin/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../services/auth.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final List<Widget> screenList = const [
    Body(),
    CallScreen(),
    PeopleScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final String? profilePicUrl = FirebaseAuth.instance.currentUser?.photoURL;
    final selectedIndex = useState(0);
    return Scaffold(
      appBar: buildAppBar(context),
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      title: const Text("Chats"),
      actions: [
        InkWell(
          onTap: () {
            AuthMethods().signOut().then(
                  (value) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignIn(),
                    ),
                  ),
                );
          },
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.exit_to_app)),
        )
      ],
    );
  }
}
