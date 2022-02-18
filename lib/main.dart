import 'package:chat_app/services/auth.dart';
import 'package:chat_app/views/chat_screen.dart';
import 'package:chat_app/views/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: AuthMethods().getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
           if (snapshot.hasData) {
             return const HomeScreen();
           }
           else {
             return const SignIn();
           }
        },
      ),
    );
  }
}

