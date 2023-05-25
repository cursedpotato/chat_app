part of 'audio_message_widget.dart';

class _Counter extends HookWidget {
  const _Counter(this.id);

  final String id;
  @override
  Widget build(BuildContext context) {
    return Text('${formatDuration(Duration(minutes: 1))}');
  }
}
