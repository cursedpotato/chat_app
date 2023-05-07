import 'package:chat_app/features/chat/models/message_model.dart';
import 'package:chat_app/features/chat/presentation/widgets/message_types/media_message/count_images_widget.dart';
import 'package:chat_app/features/chat/presentation/widgets/message_types/media_message/rouded_corder_image.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/theme/colors.dart';
import '../../../../models/media_model.dart';

class GalleryMessageWidget extends HookConsumerWidget {
  const GalleryMessageWidget(this.messageModel, {Key? key}) : super(key: key);

  final ChatMesssageModel messageModel;

  String _thumnailOrImage(int index) {
    return messageModel.mediaList[index].mediaType == MediaType.image
        ? messageModel.mediaList[index].mediaUrl
        : (messageModel.mediaList[index] as VideoMedia).thumbnailUrl;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.66,
      child: Card(
        elevation: 1,
        color: kPrimaryColor.withOpacity(messageModel.isSender ? 1 : 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 5,
            top: 5,
            right: 5,
            bottom: 25,
          ),
          child: GestureDetector(
            onTap: () {},
            child: messageModel.mediaList.length < 4
                ? CountImagesWidget(
                    imagesCount: messageModel.mediaList.length,
                    size: 0.66,
                    image: _thumnailOrImage(0),
                  )
                : _grid(context),
          ),
        ),
      ),
    );
  }

  SizedBox _grid(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.66,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        children: [
          RoundedCornerWidget(image: _thumnailOrImage(0)),
          RoundedCornerWidget(image: _thumnailOrImage(1)),
          RoundedCornerWidget(image: _thumnailOrImage(2)),
          _gridCountImage()
        ],
      ),
    );
  }

  Padding _gridCountImage() {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: CountImagesWidget(
        imagesCount: messageModel.mediaList.length,
        size: 0.66,
        image: _thumnailOrImage(3),
      ),
    );
  }
}
