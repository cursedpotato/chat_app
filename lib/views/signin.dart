import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messenger Clone"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              "Welcome to Capychat",
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.w800),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                minimumSize: const Size(double.infinity, 50)
              ),
              icon: const Icon(FontAwesomeIcons.google, color:  Colors.red,),
              label: const Text("Sign in with Google"),
              onPressed: () {
                AuthMethods().signInWithGoogle(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
