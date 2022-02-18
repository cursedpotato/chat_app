import 'package:chat_app/services/auth.dart';
import 'package:chat_app/views/signin.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Capybara chat"),
          actions: [
            InkWell(
              onTap: () {
                AuthMethods().signOut().then((_) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const SignIn()));
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.exit_to_app),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(24)
              ),
              child: Row(
                children: const [
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "username"),
                  )),
                  Icon(Icons.search)
                ],
              ),
            )
          ],
        ));
  }
}
