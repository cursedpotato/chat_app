import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/models/chat_user_model.dart';
import 'package:chat_app/core/widgets/progress_hud.dart';
import 'package:chat_app/features/home/viewmodel/chatroom_viewmodel.dart';
import 'package:chat_app/features/home/viewmodel/chattees_viewmodel.dart';
import 'package:chat_app/features/home/viewmodel/search_viewmodel.dart';
import 'package:chat_app/features/home/views/widgets/people_screen_widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../chat/views/screens/messages_screen.dart';

class PeopleScreen extends ConsumerWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = ref.watch(searchViewModel).isSearching;

    log(isSearching.toString());
    return SafeArea(
      child: ProgressHUD(
        inAsyncCall: isSearching,
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.05,
          ),
          child: Column(
            children: const [
              _AnimatedSearchBar(),
              SizedBox(height: 16),
              _SearchList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchList extends ConsumerWidget {
  const _SearchList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsList = ref.watch(searchViewModel).users;

    return Expanded(
      child: ListView.builder(
        itemCount: resultsList.length,
        itemBuilder: (_, int index) => _CustomListTile(
          userModel: resultsList[index],
        ),
      ),
    );
  }
}

class _CustomListTile extends ConsumerWidget {
  const _CustomListTile({
    required this.userModel,
  });

  final ChatUserModel userModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {
        ref.read(chatteesViewModel.notifier).addChattee(userModel);
        ref
            .read(chatRoomViewModel.notifier)
            .createChatroom()
            .then((value) => Navigator.of(context).pushNamed(
                  MessagesScreen.routeName,
                ));
      },
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(
          userModel.profilePic,
        ),
        radius: 24,
      ),
      title: Text(userModel.name),
    );
  }
}

class _AnimatedSearchBar extends HookConsumerWidget {
  const _AnimatedSearchBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    //------------
    // Controllers
    //------------

    TextEditingController searchController = useTextEditingController();
    return SlideTransition(
      position: animationOffset,
      child: SearchBarWidget(
        searchController: searchController,
        onTap: () {
          ref.read(searchViewModel.notifier).getUsers(
                searchController.text,
              );
          searchController.clear();
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
