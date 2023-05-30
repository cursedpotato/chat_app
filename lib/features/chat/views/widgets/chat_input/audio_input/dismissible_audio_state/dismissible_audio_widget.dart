import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../utils/format_duration_util.dart';
import '../../../../../../../core/utils/utility_widgets.dart';
import '../../../../../viewmodel/chat_input_viewmodel.dart';
import '../../../../../viewmodel/recording_viewmodel.dart';

part 'recording_counter.dart';
part 'slide_to_dismiss_widget.dart';

class DismissibleAudioWidget extends StatelessWidget {
  const DismissibleAudioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: const [
          PreventKeyboardClosing(),
          _SlideToDisposeWidget(),
          _RecordingCounter(),
        ],
      ),
    );
  }
}
