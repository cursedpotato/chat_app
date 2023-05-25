part of 'audio_message_widget.dart';

class _SpeedButton extends HookWidget {
  const _SpeedButton(this.id);

  final String id;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: ElevatedButton(
        onPressed: () {
          // if (speedValue == 1.0) audioPlayer.setSpeed(1.25);
          // if (speedValue == 1.25) audioPlayer.setSpeed(1.50);
          // if (speedValue == 1.5) audioPlayer.setSpeed(1.0);
        },
        child: const Text('1.5'),
      ),
    );
  }
}
