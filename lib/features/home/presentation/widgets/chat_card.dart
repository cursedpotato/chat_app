import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/home/models/chatroom_model.dart';
import 'package:chat_app/features/chat/presentation/screens/chatroom_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/routes/strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/sizes.dart';
import '../../../../core/utils/get_chatroom_id_util.dart';
import '../../providers/user_provider.dart';
import '../../services/database_methods.dart';

final chatroomId = StateProvider((ref) => "");

class ChatCard extends HookConsumerWidget {
  final bool showOnlyActive;
  final ChatroomModel chatroomModel;
  const ChatCard({
    Key? key,
    required this.showOnlyActive,
    required this.chatroomModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final DateTime fiveMinAgo =
        DateTime.now().subtract(const Duration(minutes: 5));

    bool isActive = false;
    bool isOnlyActive = false;

    late final username =
        chatroomModel.id!.replaceAll(chatterUsername!, "").replaceAll("_", "");
    late final getThisUserInfo =
        useMemoized(() => DatabaseMethods().getUserInfo(username));
    late final userFuture = useFuture(getThisUserInfo);

    bool isComplete = userFuture.hasData &&
        userFuture.connectionState == ConnectionState.done;
    if (isComplete) {
      isOnlyActive = ((showOnlyActive && isActive) || (!showOnlyActive));
    }

    if (isOnlyActive == false || isComplete == false) return const SizedBox();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MessagesScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding * 0.75,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      // TODO: add profile pic
                      CachedNetworkImageProvider(noImage),
                ),
                isActive ? activityDot(context) : const SizedBox(),
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // TODO: add name
                      "TODO",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        chatroomModel.lastMessage!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(chatroomModel.dateToString()),
            )
          ],
        ),
      ),
    );
  }

  Positioned activityDot(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
