import 'package:chat_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messenger clone"),
      ),
      body: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.black,
            minimumSize: const Size(double.infinity, 50)),
        onPressed: () {
          final provider = Provider.of<AuthMethods>(context, listen: false);
          provider.googleSignIn;
        },
        icon: const FaIcon(FontAwesomeIcons.google),
        label: const Text("Sign up with Google"),
      ),
    );
  }
}
