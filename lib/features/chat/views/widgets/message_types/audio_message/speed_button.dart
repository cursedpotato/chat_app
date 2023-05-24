part of 'audio_message_widget.dart';

class _SpeedButton extends HookWidget {
  const _SpeedButton({
    Key? key,
    required this.audioPlayer,
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    final speedSnapshot = useStream(audioPlayer.speedStream);

    if (!speedSnapshot.hasData) return const Text("1.0");

    final speedValue = speedSnapshot.data;

    return SizedBox(
      height: 20,
      width: 20,
      child: ElevatedButton(
        onPressed: () {
          if (speedValue == 1.0) audioPlayer.setSpeed(1.25);
          if (speedValue == 1.25) audioPlayer.setSpeed(1.50);
          if (speedValue == 1.5) audioPlayer.setSpeed(1.0);
        },
        child: Text('$speedValue'),
      ),
    );
  }
}
