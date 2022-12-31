import 'package:camera/camera.dart';
import 'package:chat_app/screens/home/home_screen.dart';

import 'package:chat_app/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'firebase_options.dart';

import 'screens/signin/signin_screen.dart';

final camerasList = StateProvider(
  (ref) => [],
);

late List<CameraDescription> _cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    

    useEffect(() {
      
      ref.read(camerasList.notifier).state = _cameras;
      return ;
    }, []);
    getCurrentUser() async {
      return FirebaseAuth.instance.currentUser;
    }

    return MaterialApp(
      title: 'Capychat',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
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
