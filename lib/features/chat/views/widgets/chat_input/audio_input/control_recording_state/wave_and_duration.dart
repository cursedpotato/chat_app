part of 'control_recording_widget.dart';

class _WaveAndDuration extends ConsumerWidget {
  const _WaveAndDuration();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final recorderCtrl = ref.watch(recorderViewModelProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          formatDuration(recorderCtrl.duration),
        ),
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
            size: Size(width * 0.8, 24),
            recorderController: recorderCtrl.recorderController!,
          ),
        ),
      ],
    );
  }
}
