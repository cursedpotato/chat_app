part of 'control_recording_widget.dart';

class _Controls extends HookConsumerWidget {
  const _Controls(this.animationController);

  final AnimationController animationController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderCtrl = ref.watch(recorderViewModelProvider);
    final recorderCtrlRead = ref.read(recorderViewModelProvider.notifier);
    final toggleRec = useState(true);
    resumeRecording() async => await recorderCtrlRead.startRecording();
    pauseRecording() async => await recorderCtrlRead.pauseRecording();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            // When the reverse ends we have a listener that will set the showControlRec provider to false
            animationController.reverse();
            recorderCtrlRead.deleteRecording();
          },
          icon: const Icon(Icons.delete),
        ),
        IconButton(
          onPressed: () {
            toggleRec.value = !toggleRec.value;
            if (recorderCtrl.isRecording) {
              pauseRecording().then(
                (value) => recorderCtrlRead.updateIsRecording(false),
              );
            }
            resumeRecording().then(
              (value) => recorderCtrlRead.updateIsRecording(true),
            );
          },
          icon:
              toggleRec.value ? const Icon(Icons.pause) : const Icon(Icons.mic),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            animationController.reverse();
            recorderCtrlRead.stopRecording();
          },
        )
      ],
    );
  }
}
