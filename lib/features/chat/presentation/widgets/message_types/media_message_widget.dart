import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/message_model.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../../core/theme/colors.dart';

class MediaMessageWidget extends HookConsumerWidget {
  const MediaMessageWidget(this.messageModel, {Key? key}) : super(key: key);

  final ChatMesssageModel messageModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        child: Card(
          elevation: 1,
          color: kPrimaryColor.withOpacity(messageModel.isSender! ? 1 : 0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 5,
              top: 5,
              right: 5,
              bottom: 25,
            ),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SingleImageWidget extends StatelessWidget {
  final String mediaUrl;
  final bool isVideoThumnail;
  const SingleImageWidget(this.mediaUrl, this.isVideoThumnail, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    debugPrint("This is the link you are looking for: ");
    return Stack(
      children: [
        CachedNetworkImage(imageUrl: mediaUrl),
        isVideoThumnail
            ? const Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.play_arrow,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}

class GalleryWidget extends StatelessWidget {
  const GalleryWidget(
      {Key? key, required this.messageModel, required this.contentType})
      : super(key: key);

  final List<ContentType> contentType;
  final List<ChatMesssageModel> messageModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: PhotoViewGallery.builder(
              backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor),
              itemCount: contentType.length,
              builder: (_, index) {
                return PhotoViewGalleryPageOptions.customChild(
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 1.1,
                  child: const SizedBox(),
                );
              },
              loadingBuilder: (_, __) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
