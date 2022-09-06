import 'package:chat_app/globals.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Center(
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      "https://icon-library.com/images/no-user-image-icon/no-user-image-icon-3.jpg"),
                ),
                Positioned(
                    top: 60,
                    left: 60,
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt_outlined))),
              ],
            ),
          ),
          Text(chatterUsername!),

          // Add column
        ],
      ),
    );
  }
}
