import 'dart:async';
import 'dart:io';

import 'package:chat_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:video_player/video_player.dart';

import '../../../../../core/theme/sizes.dart';
import '../../../services/messaging_methods.dart';
import 'package:video_compress/video_compress.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({Key? key, required this.imageFileList}) : super(key: key);

  final List<File> imageFileList;
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
                bool isVideo = imageFileList[index].path.contains(".mp4");

                if (isVideo) {
                  return PhotoViewGalleryPageOptions.customChild(
                    initialScale: PhotoViewComputedScale.contained * 0.8,
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 1.1,
                    child: VideoPreview(videoFile: imageFileList[index]),
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
          ImgPrevTextField(
            imageFileList: imageFileList,
          )
        ],
      ),
    );
  }
}

class VideoPreview extends HookWidget {
  const VideoPreview({Key? key, required this.videoFile}) : super(key: key);

  final File videoFile;

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    final videoController = useState(VideoPlayerController.file(videoFile));

    useEffect(() {
      return () {
        videoController.value.dispose();
      };
    }, []);

    getThumbnail() async {
      final thumbnailFile = await VideoCompress.getFileThumbnail(
        videoFile.path,
        quality: 50, // default(100)
        position: -1, // default(-1)
      );
      return thumbnailFile;
    }

    final thumbNail = useFuture(useMemoized(() => getThumbnail()));

    if (!thumbNail.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    return videoController.value.value.isInitialized
        ? VideoPlayerWidget(videoController)
        // Video Preview
        : Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.file(thumbNail.data!),
              ),
              if (isLoading.value)
                const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              else
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        isLoading.value = true;
                        videoController.value.initialize().then((value) {
                          isLoading.value = false;
                          videoController.value.play();
                        });
                      },
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                  ),
                ),
            ],
          );
  }
}

class VideoPlayerWidget extends HookWidget {
  const VideoPlayerWidget(this.videoController, {Key? key}) : super(key: key);

  final ValueNotifier<VideoPlayerController> videoController;
  @override
  Widget build(BuildContext context) {
    Stream<bool> playingState(VideoPlayerController videoController) async* {
      while (true) {
        await Future.delayed(const Duration(milliseconds: 100));
        yield videoController.value.isPlaying;
      }
    }

    final playingSnapshot = useStream(playingState(videoController.value));
    return GestureDetector(
      onTap: () {
        playingSnapshot.data ?? false
            ? videoController.value.pause()
            : videoController.value.play();
      },
      child: AspectRatio(
        aspectRatio: videoController.value.value.aspectRatio,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: VideoPlayer(videoController.value),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  playingSnapshot.data ?? false
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImgPrevTextField extends HookConsumerWidget {
  const ImgPrevTextField({Key? key, required this.imageFileList})
      : super(key: key);

  final List<File> imageFileList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 32,
            color: const Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextField(
                controller: textController,
                maxLength: 800,
                minLines: 1,
                maxLines: 5, // This way the textfield grows
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  // This hides the counter that appears when you set a chat limit
                  counterText: "",
                  hintText: "Image description...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
