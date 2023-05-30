part of 'dismissible_audio_widget.dart';

class _RecordingCounter extends HookConsumerWidget {
  const _RecordingCounter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We use focus node instead of autofocus, because the later doesn't work when the textfield is nested

    AnimationController opacityController =
        useAnimationController(duration: const Duration(milliseconds: 800))
          ..repeat(reverse: true);

    final recorderCtrl = ref.watch(recorderViewModelProvider);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeTransition(
            opacity: CurvedAnimation(
              parent: opacityController,
              curve: Curves.easeIn,
            ),
            child: const Icon(
              Icons.surround_sound_outlined,
              color: Colors.red,
            ),
          ),
          // We place this widget to prevent the keyboard from closing, giving the user a bad experience
          const SizedBox(
            width: 10,
            height: 48,
          ),
          Flexible(
            child: Text(
              formatDuration(recorderCtrl.duration),
            ),
          ),
          const SizedBox(width: 10)
        ],
      ),
    );
  }
}
