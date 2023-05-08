import 'package:chat_app/features/home/views/widgets/people_screen_widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PeopleScreen extends HookConsumerWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController searchController = useTextEditingController();

    //------------
    // Animations
    //------------
    late final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );
    late final Animation<Offset> animationOffset = useMemoized(
      () => Tween<Offset>(
        begin: const Offset(0.0, -1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.bounceInOut),
      ),
    );

    animationController.forward();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.05,
        ),
        child: Column(
          children: [
            SlideTransition(
              position: animationOffset,
              child: SearchBarWidget(
                searchController: searchController,
                onTap: () {
                  searchController.clear();
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget userList(List<DocumentSnapshot>? documentList, WidgetRef ref) {
  //   return Expanded(
  //     child: ListView.builder(
  //       itemCount: documentList!.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         UserModel userModel = UserModel.fromDocument(documentList[index]);
  //         return userTile(userModel, context, ref);
  //       },
  //     ),
  //   );
  // }

  // Widget userTile(UserModel userModel, BuildContext context, WidgetRef ref) {
  //   return ListTile(
  //     onTap: () => createChat(context, userModel, ref),
  //     leading: CircleAvatar(
  //       backgroundImage: CachedNetworkImageProvider(userModel.pfpUrl!),
  //       radius: 24,
  //     ),
  //     title: Text(userModel.name!),
  //   );
  // }

  // void createChat(BuildContext context, UserModel userModel, WidgetRef ref) {
  //   var chatRoomId =
  //       getChatRoomIdByUsernames(chatterUsername!, userModel.username!);
  //   Map<String, dynamic> chatRoomInfoMap = {
  //     "users": [chatterUsername, userModel.username]
  //   };
  //   DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);

  //   ref.read(userProvider.notifier).copyUserModel(userModel);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const MessagesScreen(),
  //     ),
  //   );
  // }
}
