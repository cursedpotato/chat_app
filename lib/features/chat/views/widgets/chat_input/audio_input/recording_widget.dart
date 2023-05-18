import 'package:audio_waveforms/audio_waveforms.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/utils/utility_widgets.dart';
import 'mic_animation.dart';
import 'slide_to_dismiss_widget.dart';
import 'trash_animation.dart';

// Recording widget related variables

// TODO: Plug this into a viewmodel

final recordDuration = StateProvider((ref) => '0:00');

final sliderPosition = StateProvider.autoDispose((ref) => 0.0);

final stackSize = StateProvider((ref) => 0.0);

final showAudioWidget = StateProvider.autoDispose((ref) => false);

final wasAudioDiscarted = StateProvider.autoDispose((ref) => false);

final showControlRec = StateProvider.autoDispose((ref) => false);

final isRecording = StateProvider((ref) => false);

final recController = StateProvider(
  (ref) => RecorderController()
    ..androidEncoder = AndroidEncoder.aac
    ..androidOutputFormat = AndroidOutputFormat.mpeg4
    ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
    ..sampleRate = 16000
    ..bitRate = 64000,
);

class RecordingWidget extends HookConsumerWidget {
  const RecordingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This function was created because nesting ternary oparators within the Stack list is not very readable
    List<Widget> stackList() {
      if (ref.watch(wasAudioDiscarted)) {
        return const [
          PreventKeyboardClosing(),
          AnimatedMic(),
          AnimatedTrash(),
        ];
      }
      if (!ref.watch(wasAudioDiscarted) && !ref.watch(showControlRec)) {
        return const [
          SlideToDisposeWidget(),
          RecordingCounter(),
          PreventKeyboardClosing()
        ];
      }

      return const [ControlRecordingWidget(), PreventKeyboardClosing()];
    }

    return Expanded(
      child: MeasurableWidget(
        onChange: (Size size) =>
            ref.read(stackSize.notifier).state = size.width,
        child: Stack(children: stackList()),
      ),
    );
  }
}

class ControlRecordingWidget extends HookConsumerWidget {
  const ControlRecordingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggleRec = useState(true);
    resumeRecording() async =>
        await ref.read(recController.notifier).state.record();
    pauseRecording() async =>
        await ref.read(recController.notifier).state.pause();

    // ------------------------------------------
    // Transform translate animation related logic
    // ------------------------------------------
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 500));
    late final Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 80),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.ease),
    );
    animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.dismissed) {
        ref.read(showControlRec.notifier).state = false;
      }
    });

    useEffect(() {
      animationController.forward();
      return;
    });

    return AnimatedBuilder(
      animation: offsetAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: offsetAnimation.value,
          child: child,
        );
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(ref.watch(recordDuration)),
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
                  size: Size(ref.watch(stackSize) * 0.90, 24),
                  recorderController: ref.watch(recController),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  // When the reverse ends we have a listener that will set the showControlRec provider to false
                  animationController.reverse();
                  ref.read(recController.notifier).state.stop();
                },
                icon: const Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () {
                  toggleRec.value = !toggleRec.value;
                  if (ref.watch(isRecording)) {
                    pauseRecording().then(
                      (value) => ref.read(isRecording.notifier).state = false,
                    );
                  }
                  resumeRecording().then(
                    (value) => ref.read(isRecording.notifier).state = true,
                  );
                },
                icon: toggleRec.value
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.mic),
              ),
              IconButton(icon: const Icon(Icons.send), onPressed: () {})
            ],
          ),
        ],
      ),
    );
  }
}

class RecordingCounter extends HookConsumerWidget {
  const RecordingCounter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We use focus node instead of autofocus, because the later doesn't work when the textfield is nested

    AnimationController opacityController =
        useAnimationController(duration: const Duration(milliseconds: 800))
          ..repeat(reverse: true);

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
          Flexible(child: Text(ref.watch(recordDuration))),
          const SizedBox(width: 10)
        ],
      ),
    );
  }
}
