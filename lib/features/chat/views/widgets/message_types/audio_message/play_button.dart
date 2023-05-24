part of 'audio_message_widget.dart';

class _PlayButton extends HookWidget {
  const _PlayButton({Key? key, required this.audioPlayer}) : super(key: key);

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    final playerIcon = useState(Icons.play_arrow);

    final stateSnapshot = useStream(audioPlayer.playerStateStream);

    final processingState = stateSnapshot.data?.processingState;

    final isLoading = processingState == ProcessingState.buffering ||
        processingState == ProcessingState.loading ||
        !stateSnapshot.hasData;
    final isCompleted = processingState == ProcessingState.completed;

    if (isLoading) {
      return IconButton(onPressed: () {}, icon: Icon(playerIcon.value));
    }
    // To listen to the audio again when finished
    if (isCompleted) {
      audioPlayer.seek(Duration.zero);
      audioPlayer.pause();
    }

    final isPlaying = stateSnapshot.requireData.playing;
    return IconButton(
      icon: Icon(
        isPlaying
            ? playerIcon.value = Icons.pause
            : playerIcon.value = Icons.play_arrow,
      ),
      onPressed: () => isPlaying ? audioPlayer.pause() : audioPlayer.play(),
    );
  }
}
