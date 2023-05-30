import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../models/media_model.dart';

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

          return imageMedia(mediaList[index]);
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
      child: const Text('This is a video'),
    );
  }

  PhotoViewGalleryPageOptions imageMedia(Media media) {
    return PhotoViewGalleryPageOptions.customChild(
      initialScale: PhotoViewComputedScale.contained * 0.8,
      minScale: PhotoViewComputedScale.contained * 0.8,
      maxScale: PhotoViewComputedScale.covered * 1.1,
      child: CachedNetworkImage(imageUrl: media.mediaUrl),
    );
  }
}
