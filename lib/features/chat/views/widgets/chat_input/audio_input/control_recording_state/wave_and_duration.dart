part of 'control_recording_widget.dart';

class _WaveAndDuration extends StatelessWidget {
  const _WaveAndDuration({
    required this.recorderCtrl,
    required this.inputCtrl,
  });

  final RecordingModel recorderCtrl;
  final ChatInputModel inputCtrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          formatDuration(recorderCtrl.duration),
        ),
        const PreventKeyboardClosing(),
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: AudioWaveforms(
            waveStyle: const WaveStyle(
              waveCap: StrokeCap.round,
              spacing: 8.0,
              showBottom: true,
              extendWaveform: true,
              showMiddleLine: false,
            ),
            size: Size(inputCtrl.stackSize * 0.90, 24),
            recorderController: recorderCtrl.recorderController!,
          ),
        ),
      ],
    );
  }
}
