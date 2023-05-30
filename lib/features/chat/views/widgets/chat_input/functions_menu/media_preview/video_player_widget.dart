part of 'media_preview_widget.dart';

class _VideoPlayerWidget extends HookWidget {
  const _VideoPlayerWidget(this.videoController, {Key? key}) : super(key: key);

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
