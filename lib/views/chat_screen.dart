import 'package:chat_app/helperfunctions/sharedpreferences_helper.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatwithUsername, name;
  const ChatScreen(
      {Key? key, required this.chatwithUsername, required this.name})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? chatRoomId, messageId;
  String? myName, myProfilePic, myUserName, myEmail;

  void getInfoFromSharePreference() async {
    myName = await SharedPreferencesHelper().getDisplayName();
    myProfilePic = await SharedPreferencesHelper().getUserProfile();
    myUserName = await SharedPreferencesHelper().getUserName();
    myName = await SharedPreferencesHelper().getUserEmail();

    chatRoomId = getChatRoomId(widget.chatwithUsername, myUserName);
  }

  String getChatRoomId(String? a, String? b) {
    if (a!.substring(0, 1).codeUnitAt(0) > b!.substring(0, 1).codeUnitAt(0)) {
      // ignore: unnecessary_string_escapes
      return "$b\_$a";
    } else {
      // ignore: unnecessary_string_escapes
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(widget.name),
    ));
  }
}
