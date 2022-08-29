import 'package:chat_app/globals.dart';
import 'package:chat_app/screens/calls_screen.dart';
import 'package:chat_app/screens/home/home_body.dart';
import 'package:chat_app/screens/people_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final List<Widget> screenList = const [
    Body(),
    PeopleScreen(),
    CallScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final String? profilePicUrl = FirebaseAuth.instance.currentUser?.photoURL;
    String noImage =
        'https://secure.gravatar.com/avatar/ef9463e636b415ee041791a6a3764104?s=250&d=mm&r=g';
    final selectedIndex = useState(0);
    return Scaffold(
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
                backgroundImage: NetworkImage(profilePicUrl ?? noImage),
              ),
              label: "Profile")
        ],
      ),
    );
  }

  
}
