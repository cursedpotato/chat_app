part of 'audio_message_widget.dart';

class _Counter extends HookWidget {
  const _Counter({Key? key, required this.audioPlayer}) : super(key: key);
  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    final bool isPlaying =
        useStream(audioPlayer.playerStateStream).data?.playing ?? false;

    final durationSnapshot = useStream(audioPlayer.durationStream);

    final positionSnapshot = useStream(audioPlayer.positionStream);

    if (!durationSnapshot.hasData) return const Text('0:00');

    timeFormat(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String seconds = twoDigits(duration.inSeconds.remainder(60));
      String minutes = duration.inMinutes.toString();
      final map = {'seconds': seconds, 'minutes': minutes};
      return map;
    }

    ValueNotifier<Map> time = useState(timeFormat(durationSnapshot.data!));

    if (isPlaying) time.value = timeFormat(positionSnapshot.data!);

    return Text('${time.value["minutes"]}:${time.value["seconds"]}');
  }
}
