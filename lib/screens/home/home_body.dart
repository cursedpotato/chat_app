import 'package:chat_app/globals.dart';
import 'package:chat_app/screens/home/chat_card.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/screens/home/filledout_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


class Body extends HookWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var future = useMemoized(() => DatabaseMethods().getChatRooms());

    Stream<QuerySnapshot>? chatroomStream = useFuture(future).data;

    useEffect(
      () {
        DatabaseMethods().updateUserTs();
        return;
      },
    );

    // This variable was created to filter chatroom stream data and toggle buttons

    ValueNotifier<bool> isActive = useState(false);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
            kDefaultPadding,
            0,
            kDefaultPadding,
            kDefaultPadding,
          ),
          //TODO: Dark theme does weird thing
          color: kPrimaryColor,
          child: Row(
            children: [
              FillOutlineButton(
                press: () => isActive.value = !isActive.value,
                text: "Recent Messages",
                isFilled: !isActive.value,
              ),
              const SizedBox(width: kDefaultPadding),
              FillOutlineButton(
                press: () => isActive.value = !isActive.value,
                text: "Active",
                isFilled: isActive.value,
              ),
            ],
          ),
        ),
        StreamBuilder(
          stream: chatroomStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            bool isWaiting =
                snapshot.connectionState == ConnectionState.waiting;
            if (isWaiting) {
              return const LinearProgressIndicator();
            }

            bool isRecent = snapshot.hasData && !isActive.value;
            if (isRecent) {
              // TODO: Add conditional that filters if users are active or not
              List<DocumentSnapshot> documentList = snapshot.data!.docs;
              return chatroomLb(documentList);
            }

            bool isAvailable = snapshot.hasData && isActive.value;
            if (isAvailable) {
              List<DocumentSnapshot> documentList = snapshot.data!.docs;
              return chatroomLb(documentList);
            }

            // TODO: Make an error screen
            return const Text("Something went wrong");
          },
        ),
      ],
    );
  }

  Widget chatroomLb(List<DocumentSnapshot> documentList) {
    return Expanded(
      child: ListView.builder(
        itemCount: documentList.length,
        itemBuilder: (BuildContext context, int index) {
          DocumentSnapshot documentSnapshot = documentList[index];
          return ChatCard(
            documentSnapshot: documentSnapshot,
          );
        },
      ),
    );
  }
}

