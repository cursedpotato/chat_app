import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/home/presentation/screens/calls_screen.dart';
import 'package:chat_app/features/home/presentation/screens/people_screen.dart';
import 'package:chat_app/features/home/presentation/screens/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/routes/strings.dart';
import '../../../../core/theme/colors.dart';
import 'chatrooms_screen.dart';

class HomeScreen extends HookWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List<Widget> screenList = const [
    ChatroomScreen(),
    PeopleScreen(),
    CallScreen(),
    ProfileScreen(),
  ];

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> selectedIndex = useState(0);

    return Scaffold(
      body: screenList[selectedIndex.value],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        color: khighlightColor,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor:
            selectedIndex.value == 3 ? Colors.transparent : khighlightColor,
        onTap: (int index) {
          selectedIndex.value = index;
        },
        items: [
          const Icon(Icons.message),
          const Icon(Icons.people),
          const Icon(Icons.call),
          CircleAvatar(
            radius: 16,
            backgroundImage:
                CachedNetworkImageProvider(profilePicUrl ?? noImage),
          ),
        ],
      ),
    );
  }
}
