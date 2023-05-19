import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chat_app/features/chat/utils/format_duration_util.dart';
import 'package:chat_app/features/chat/viewmodel/chat_input_viewmodel.dart';
import 'package:chat_app/features/chat/viewmodel/recording_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/utils/utility_widgets.dart';
import 'mic_animation.dart';
import 'slide_to_dismiss_widget.dart';
import 'trash_animation.dart';

class RecordingWidget extends HookConsumerWidget {
  const RecordingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This function was created because nesting ternary oparators within the Stack list is not very readable
    final inputCtrl = ref.watch(chatInputViewModelProvider);
    List<Widget> stackList() {
      if (inputCtrl.wasRecoringDismissed) {
        return const [
          PreventKeyboardClosing(),
          AnimatedMic(),
          AnimatedTrash(),
        ];
      }
      if (inputCtrl.wasRecoringDismissed && !inputCtrl.showControlRec) {
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
        onChange: (Size size) => ref
            .read(chatInputViewModelProvider.notifier)
            .updateStackSize(size.width),
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
    final recorderCtrl = ref.watch(recorderViewModelProvider);
    final recorderCtrlRead = ref.read(recorderViewModelProvider.notifier);

    final inputCtrl = ref.watch(chatInputViewModelProvider);

    resumeRecording() async => await recorderCtrlRead.startRecording();
    pauseRecording() async => await recorderCtrlRead.pauseRecording();

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
        ref
            .read(chatInputViewModelProvider.notifier)
            .updateShowControlRec(false);
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
          ),
          Row(
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
