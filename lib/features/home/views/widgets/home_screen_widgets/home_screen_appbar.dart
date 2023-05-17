import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../auth/views/screens/signin_screen.dart';

AppBar homeAppbar(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).primaryColor,
    automaticallyImplyLeading: true,
    title: AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText("Capychat"),
        TypewriterAnimatedText("Connect with others"),
        TypewriterAnimatedText("Explore"),
        TypewriterAnimatedText("Talk with people you care about"),
        WavyAnimatedText("Chat!")
      ],
      totalRepeatCount: 1,
    ),
    actions: [
      InkWell(
        onTap: () {
          FirebaseAuth.instance.signOut().then(
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
          child: const Icon(Icons.exit_to_app),
        ),
      )
    ],
  );
}
