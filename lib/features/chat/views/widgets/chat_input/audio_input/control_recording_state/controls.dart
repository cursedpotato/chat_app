part of 'control_recording_widget.dart';

class _Controls extends StatelessWidget {
  const _Controls({
    required this.animationController,
    required this.recorderCtrlRead,
    required this.toggleRec,
    required this.recorderCtrl,
  });

  final AnimationController animationController;
  final RecorderViewModel recorderCtrlRead;
  final ValueNotifier<bool> toggleRec;
  final RecordingModel recorderCtrl;

  @override
  Widget build(BuildContext context) {
    resumeRecording() async => await recorderCtrlRead.startRecording();
    pauseRecording() async => await recorderCtrlRead.pauseRecording();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            // When the reverse ends we have a listener that will set the showControlRec provider to false
            animationController.reverse();
            recorderCtrlRead.stopRecording();
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
        IconButton(icon: const Icon(Icons.send), onPressed: () {})
      ],
    );
  }
}
