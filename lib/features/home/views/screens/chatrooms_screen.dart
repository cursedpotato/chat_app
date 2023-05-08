import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/features/home/views/widgets/filledout_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/theme/sizes.dart';
import '../../../auth/views/screens/signin_screen.dart';

class ChatroomScreen extends HookWidget {
  const ChatroomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useFocusNode().unfocus();
    // TODO: find a better way to update user activity

    // This variable was created to filter chatroom stream data and toggle buttons
    ValueNotifier<bool> isActive = useState(false);
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                kDefaultPadding,
                0,
                kDefaultPadding,
                kDefaultPadding,
              ),
              color: Theme.of(context).primaryColor,
              child: Row(
                children: [
                  FillOutlineButton(
                    press: () => isActive.value = !isActive.value,
                    text: "Recent Messages",
                    isFilled: !isActive.value,
                  ),
                  const SizedBox(width: kDefaultPadding),
                  FillOutlineButton(
                    press: () => isActive.value = !isActive.value,
                    text: "Active",
                    isFilled: isActive.value,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
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
}
