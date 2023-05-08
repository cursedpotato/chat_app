import 'package:chat_app/core/theme/app_theme.dart';
import 'package:chat_app/features/chat/presentation/screens/chatroom_screen.dart';
import 'package:chat_app/features/home/views/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'firebase_options.dart';

import 'features/auth/views/screens/signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    getCurrentUser() async {
      return FirebaseAuth.instance.currentUser;
    }

    return MaterialApp(
      title: 'Capychat',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routes: {
        SignIn.routeName: (context) => const SignIn(),
        HomeScreen.routeName: (context) => HomeScreen(),
        MessagesScreen.routeName: (context) => const MessagesScreen(),
      },
      home: FutureBuilder(
        future: getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const SignIn();
          }
          return HomeScreen();
        },
      ),
    );
  }
}
