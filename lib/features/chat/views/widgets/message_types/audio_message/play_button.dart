part of 'audio_message_widget.dart';

class _PlayButton extends HookConsumerWidget {
  const _PlayButton(this.id);

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioPlayerVMW = ref.watch(audioPlayerVM(id));
    final ProcessingState processingState = ref.watch(
      audioPlayerVM(id).select((value) => value.processingState),
    );

    if (processingState == ProcessingState.completed) {
      return IconButton(
        icon: const Icon(Icons.replay),
        onPressed: () {
          ref.read(audioPlayerVM(id).notifier).replay();
        },
      );
    }

    return IconButton(
      icon: Icon(
        audioPlayerVMW.isPlaying ? Icons.pause : Icons.play_arrow,
      ),
      onPressed: () {
        ref.read(audioPlayerVM(id).notifier).togglePlay();
      },
    );
  }
}
