part of 'media_preview_widget.dart';

class _VideoPreview extends HookWidget {
  const _VideoPreview({Key? key, required this.videoFile}) : super(key: key);

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
        ? _VideoPlayerWidget(videoController)
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
