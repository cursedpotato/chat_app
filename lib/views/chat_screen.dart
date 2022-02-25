import 'package:chat_app/helperfunctions/sharedpreferences_helper.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class ChatScreen extends StatefulWidget {
  final String chatwithUsername, name;
  const ChatScreen(
      {Key? key, required this.chatwithUsername, required this.name})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  String? chatroomId, messageId;
  String? myName, myProfilePic, myUserName, myEmail;

  Stream<QuerySnapshot>? messageStream;

  getInfoFromSharePreference() async {
    myName = await SharedPreferencesHelper().getDisplayName();
    myProfilePic = await SharedPreferencesHelper().getUserProfile();
    myUserName = await SharedPreferencesHelper().getUserName();
    myEmail = await SharedPreferencesHelper().getUserEmail();

    chatroomId = getChatRoomId(widget.chatwithUsername, myUserName);
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

  Widget messageTile(DocumentSnapshot ds, bool sendByme) {
    String message = ds["message"];
    return Row(
      mainAxisAlignment: sendByme ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            
            borderRadius: BorderRadius.only(
             topRight: const Radius.circular(24), 
             topLeft: const Radius.circular(24),
             bottomRight: sendByme ? const Radius.circular(0) : const Radius.circular(24),
             bottomLeft: sendByme ? const Radius.circular(24) : const Radius.circular(0),
            ),
            color: sendByme ? Colors.indigo : Colors.indigo[400],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(16),
          child: Text(message),
        ),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: messageStream,
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              padding: const EdgeInsets.only(bottom: 70, top: 16),
              itemCount: snapshot.data!.docs.length,
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return messageTile(ds,  myUserName == ds["sendBy"]);
              });
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  getAndSetMessage() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatroomId!);
    setState(() {});
  }

  addMessage(bool sendClicked) {
    if (messageController.text != "") {
      String message = messageController.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": lastMessageTs,
        "imgUrl": myProfilePic,
      };

      messageId ??= randomAlphaNumeric(12).toString();

      DatabaseMethods()
          .addMessage(chatroomId!, messageId!, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfo = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": myUserName,
        };

        DatabaseMethods().updateLastMessageSend(chatroomId!, lastMessageInfo);

        if (sendClicked) {
          // remove the text in the message input field
          messageController.clear();
          // make message id blank to get regenerated on next message send
          messageId = "";
          setState(() {
            messageId = randomAlphaNumeric(12).toString();
          });
        }
      });
    }
  }

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
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: addMessage(false),
                    controller: messageController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type a message",
                        hintStyle: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      addMessage(true);
                    },
                    child: const Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }
}
