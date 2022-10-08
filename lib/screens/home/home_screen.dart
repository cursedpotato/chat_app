import 'package:chat_app/globals.dart';
import 'package:chat_app/screens/calls_screen.dart';
import 'package:chat_app/screens/home/home_body.dart';
import 'package:chat_app/screens/people_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


class HomeScreen extends HookWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List<Widget> screenList = const [
    Body(),
    PeopleScreen(),
    CallScreen(),
    ProfileScreen(),
  ];

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    
    
    ValueNotifier<int> selectedIndex = useState(0);
    
    
    print("This is in the body ${selectedIndex.value}");
    return Scaffold(
      body: screenList[selectedIndex.value],
      bottomNavigationBar: CurvedNavigationBar(
        key:  _bottomNavigationKey,
        color: khighlightColor,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: selectedIndex.value == 3 ? Colors.transparent : khighlightColor,
        onTap: (int index) {
          selectedIndex.value = index;
          
          print("This is the index: $index, and this is the value notifier ${selectedIndex.value}");
        },
        items: [
          const Icon(Icons.message),
          const Icon(Icons.people),
          const Icon(Icons.call),
          CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(profilePicUrl ?? noImage),
              ),
        ],
      ),
    );
  }

  
}
