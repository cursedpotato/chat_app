import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chat_app/features/chat/models/recording_model.dart';
import 'package:chat_app/features/chat/models/chat_input_model.dart';
import 'package:chat_app/features/chat/viewmodel/recording_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../core/utils/utility_widgets.dart';
import '../../../../../utils/format_duration_util.dart';
import '../../../../../viewmodel/chat_input_viewmodel.dart';

part 'wave_and_duration.dart';
part 'controls.dart';

class ControlRecordingWidget extends HookConsumerWidget {
  const ControlRecordingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggleRec = useState(true);
    final recorderCtrl = ref.watch(recorderViewModelProvider);
    final recorderCtrlRead = ref.read(recorderViewModelProvider.notifier);

    final inputCtrl = ref.watch(chatInputViewModelProvider);

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
        final inputCtrlRead = ref.read(chatInputViewModelProvider.notifier);
        inputCtrlRead.updateInputState(ChatInputState.defaultState);
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
          _WaveAndDuration(recorderCtrl: recorderCtrl, inputCtrl: inputCtrl),
          _Controls(
            animationController: animationController,
            recorderCtrlRead: recorderCtrlRead,
            toggleRec: toggleRec,
            recorderCtrl: recorderCtrl,
          ),
        ],
      ),
    );
  }
}
