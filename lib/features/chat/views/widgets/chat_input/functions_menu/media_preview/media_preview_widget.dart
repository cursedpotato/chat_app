import 'dart:async';
import 'dart:io';

import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/features/chat/viewmodel/messages_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:video_player/video_player.dart';

import '../../../../../../../core/theme/sizes.dart';

import 'package:video_compress/video_compress.dart';

part 'img_prev_textfield.dart';
part 'video_preview_widget.dart';
part 'video_player_widget.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({Key? key, required this.imageFileList}) : super(key: key);

  final List<File> imageFileList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: PhotoViewGallery.builder(
              backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor),
              itemCount: imageFileList.length,
              builder: (_, index) {
                bool isVideo = imageFileList[index].path.contains(".mp4");

                if (isVideo) {
                  return PhotoViewGalleryPageOptions.customChild(
                    initialScale: PhotoViewComputedScale.contained * 0.8,
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 1.1,
                    child: _VideoPreview(videoFile: imageFileList[index]),
                  );
                }

                return PhotoViewGalleryPageOptions(
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 1.1,
                  imageProvider: FileImage(imageFileList[index]),
                );
              },
              loadingBuilder: (_, __) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          _ImgPrevTextField(
            imageFileList: imageFileList,
          )
        ],
      ),
    );
  }
}
