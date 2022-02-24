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

  getInfoFromSharePreference() async {
    myName = await SharedPreferencesHelper().getDisplayName();
    myProfilePic = await SharedPreferencesHelper().getUserProfile();
    myUserName = await SharedPreferencesHelper().getUserName();
    myEmail = await SharedPreferencesHelper().getUserEmail();

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

  getAndSetMessage() async {}

  doThisOnLauch() async {
    await getInfoFromSharePreference();
    getAndSetMessage();
  }

  @override
  void initState() {
    doThisOnLauch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Stack(
        children: [
          Row(
            children: const [Expanded(child: TextField())],
          )
        ],
      ),
    );
  }
}
