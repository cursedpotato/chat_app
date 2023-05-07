import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/theme/fonts.dart';
import 'package:chat_app/features/chat/models/message_model.dart';
import 'package:chat_app/features/chat/utils/gallery_display_text_function.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../../core/theme/colors.dart';
import '../../../models/media_model.dart';

class GalleryMessageWidget extends HookConsumerWidget {
  const GalleryMessageWidget(this.messageModel, {Key? key}) : super(key: key);

  final ChatMesssageModel messageModel;

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
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (messageModel.mediaList.length < 4)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                      child: Image(
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.width * 0.66,
                        image: CachedNetworkImageProvider(
                          _thumnailOrImage(),
                        ),
                      ),
                    ),
                  ),
                _imageNumber(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _thumnailOrImage() {
    return messageModel.mediaList[0].mediaType == MediaType.image
        ? messageModel.mediaList[0].mediaUrl
        : (messageModel.mediaList[0] as VideoMedia).thumbnailUrl;
  }

  Align _imageNumber() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        displayText(messageModel.mediaList.length),
        style: displayMediumInter,
      ),
    );
  }
}

class GalleryWidget extends StatelessWidget {
  const GalleryWidget({Key? key, required this.mediaList}) : super(key: key);

  final List<Media> mediaList;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 500,
      child: PhotoViewGallery.builder(
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        itemCount: mediaList.length,
        builder: (_, index) {
          if (mediaList[index].mediaType == MediaType.video) {
            return videoMedia();
          }

          return imageMedia();
        },
        loadingBuilder: (_, __) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions videoMedia() {
    return PhotoViewGalleryPageOptions.customChild(
      initialScale: PhotoViewComputedScale.contained * 0.8,
      minScale: PhotoViewComputedScale.contained * 0.8,
      maxScale: PhotoViewComputedScale.covered * 1.1,
      child: Text('This is a video'),
    );
  }

  PhotoViewGalleryPageOptions imageMedia() {
    return PhotoViewGalleryPageOptions.customChild(
      initialScale: PhotoViewComputedScale.contained * 0.8,
      minScale: PhotoViewComputedScale.contained * 0.8,
      maxScale: PhotoViewComputedScale.covered * 1.1,
      child: const SizedBox(),
    );
  }
}
