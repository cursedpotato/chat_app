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

class MediaType {
  final String mediaUrl;
  final bool isVideo;

  MediaType(this.mediaUrl, this.isVideo);
}

class MediaMessageWidget extends HookConsumerWidget {
  const MediaMessageWidget(this.messageModel, {Key? key}) : super(key: key);

  final ChatMesssageModel messageModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urlList = useStream(useMemoized(
      () => imageMediaStream(messageModel),
    ));

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
            child: urlList.hasData
                ? mediaType(urlList.data!)
                : const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget mediaType(List<MediaType> contentList) {
    final listLenght = contentList.length;

    bool isASingleVideo = listLenght == 1 && contentList.first.isVideo;
    if (isASingleVideo) {
      return SingleImageWidget(messageModel.thumnailUrls!.first, true);
    }

    bool isASingleImage = listLenght == 1 && !contentList.first.isVideo;
    if (isASingleImage) {
      return SingleImageWidget(messageModel.resUrls!.first, false);
    }
    return const CircularProgressIndicator();
  }

  Future<bool> urlContainsVideo(url) async {
    final storageRef = FirebaseStorage.instance;
    final metadata = await storageRef.refFromURL(url).getMetadata();

    final contentType = metadata.contentType;
    if (contentType!.isEmpty) {
      throw "There is no available metadata";
    }
    final isVideo = contentType.contains("video");

    return isVideo;
  }

  // IMPORTANT!!! the index is not the index of the list lenght of the for loop
  // but the index that is at the end of the url.
  // Why? Because lenght of the thumbnail list is not the same as the media urls.
  String getThumnail(ChatMesssageModel model, int index) {
    model.thumnailUrls!.map((e) {
      if (e.contains('resindex=$index')) {
        return e;
      }
    });

    throw "Element not found";
  }

  // This stream checks if the content of url is either a video or simple image, the purpose of this
  // is not sending a video file to an image widget which makes the app crash.

  // TODO: Change this stream so it returns a list of images or thumnails instead of just images and videos
  Stream<List<MediaType>> imageMediaStream(ChatMesssageModel model) async* {
    // DatabaseMethods().getMessageInfo(messageId, chatRoomId);
    List<MediaType> contentList = [];

    final urlList = model.resUrls;

    if (urlList == null) throw "Your list is null";

    for (var i = 0; i < urlList.length; i++) {
      final mediaUrl = urlList[i];
      final isVideo = await urlContainsVideo(mediaUrl);

      if (isVideo) {
        // get the index of the every element of the list, if it matches the for loop index return the element that matches
        final thumbnail = getThumnail(model, i);
        print("This is the thumbnail you are looking for: $thumbnail");
        contentList.add(MediaType(thumbnail, isVideo));

        yield contentList;
      }

      contentList.add(MediaType(mediaUrl, isVideo));

      yield contentList;
    }
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

class MultimediaWidget extends HookWidget {
  final List<MediaType> contentList;
  final ChatMesssageModel messsageModell;
  const MultimediaWidget(
      {Key? key, required this.contentList, required this.messsageModell})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final String galleryCover;

    useEffect(
      () {
        if (contentList.first.isVideo) {
          galleryCover = messsageModell.thumnailUrls!.first;
        }
        galleryCover = messsageModell.resUrls!.first;

        return;
      },
    );

    if (contentList.length < 5) {
      return Stack(
        children: [
          CachedNetworkImage(imageUrl: galleryCover),
          Text("${contentList.length}"),
        ],
      );
    }
    return Container();
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
