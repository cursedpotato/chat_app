import 'dart:math';

import 'package:chat_app/features/chat/models/chat_input_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../core/utils/utility_widgets.dart';
import '../../../../../viewmodel/chat_input_viewmodel.dart';

part 'mic_animation.dart';
part 'trash_animation.dart';

const animationDuration = Duration(milliseconds: 1800);

class DismissAnimation extends StatelessWidget {
  const DismissAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: const [
          PreventKeyboardClosing(),
          _AnimatedMic(),
          _AnimatedTrash(),
        ],
      ),
    );
  }
}
