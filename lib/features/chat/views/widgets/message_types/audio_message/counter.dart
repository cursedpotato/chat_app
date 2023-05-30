part of 'audio_message_widget.dart';

class _Counter extends HookConsumerWidget {
  const _Counter(this.id);

  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPlaying = ref.watch(
      audioPlayerVM(id).select((value) => value.isPlaying),
    );
    final Duration position = ref.watch(
      audioPlayerVM(id).select((value) => value.position),
    );

    final Duration duration = ref.watch(
      audioPlayerVM(id).select((value) => value.duration),
    );
    return Text(formatDuration(isPlaying ? position : duration));
  }
}
