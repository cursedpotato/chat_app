import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

isVideo() {
    
}

class MediaMessageWidget extends HookWidget {
  const MediaMessageWidget(this.chatMessagelModel, {Key? key})
      : super(key: key);

  final ChatMesssageModel chatMessagelModel;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            GalleryWidget(imageFileList: chatMessagelModel.resUrls!),
      )),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: chatMessagelModel.resUrls![0],
                )),
          ],
        ),
      ),
    );
  }
  mediaType() {

  }

  
}

class SingleImageWidget extends StatelessWidget {
  const SingleImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SingleVideoWidget extends StatelessWidget {
  const SingleVideoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MultimediaWidget extends StatelessWidget {
  const MultimediaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class GalleryWidget extends StatelessWidget {
  const GalleryWidget({Key? key, required this.imageFileList})
      : super(key: key);

  final List<String> imageFileList;
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
              itemCount: imageFileList.length,
              builder: (_, index) {
                return PhotoViewGalleryPageOptions(
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 1.1,
                  imageProvider: NetworkImage(imageFileList[index]),
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
