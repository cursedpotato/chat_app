import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String? chatwithUsername, name;
  const ChatScreen({Key? key, this.chatwithUsername, this.name}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Messenger Clone"),));
  }
}