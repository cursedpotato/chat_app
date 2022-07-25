import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_app/modelview/signin_modelview.dart';
import 'package:chat_app/pages/chats/chat_screen.dart';
import 'package:chat_app/pages/signin.dart';

import 'package:chat_app/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    'resource://drawable/logo',
    [
      NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.High,
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white)
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
          channelGroupkey: 'basic_channel_group',
          channelGroupName: 'Basic group')
    ],
    debug: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SingInModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getCurrentUser() async {
      return FirebaseAuth.instance.currentUser;
    }

    return MaterialApp(
      title: 'Capychat',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      home: SignIn(),
      // home: FutureBuilder(
      //   future: getCurrentUser(),
      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
      //     if (!snapshot.hasData) {
      //       return const SignIn();
      //     }
      //     return const ChatScreen();
      //   },
      // ),
    );
  }
}
