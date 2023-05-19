import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../viewmodel/chat_input_viewmodel.dart';

class SlideToDisposeWidget extends ConsumerWidget {
  const SlideToDisposeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // References
    final inputCtrl = ref.watch(chatInputViewModelProvider);
    late final double pointerPosition = inputCtrl.sliderPosition;
    late final double screenWidth = MediaQuery.of(context).size.width;
    late final double centerPosition = screenWidth * 0.333;
    /* We use a ternary operator because
     the pointer gives 0 at the beggining and only 
     the screenWidth remains which makes the widget go offscreen,
     therefore I chose to give a zero 
     value first so the offset doesn't get the widget out of screen */
    late final double offset =
        (pointerPosition == 0.0 ? 0.0 : pointerPosition - screenWidth).abs() /
            2;
    late final double opacity = (pointerPosition == 0.0
        ? 1.0
        : (pointerPosition / screenWidth) - offset * 0.005);

    const colorizeColors = [
      Colors.black,
      Colors.grey,
    ];

    return Transform.translate(
      offset: Offset(centerPosition - offset, 0),
      child: Opacity(
        // If opacity is less than zero return zero
        opacity: opacity < 0 ? 0.0 : opacity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                ColorizeAnimatedText(
                  'slide to cancel',
                  textStyle: Theme.of(context).textTheme.bodyMedium!,
                  colors: colorizeColors,
                )
              ],
            ),
            // Text('slide to cancel' ),
            const SizedBox(
              height: 48,
            ),

            const Icon(Icons.arrow_back_ios_new_outlined),
          ],
        ),
      ),
    );
  }
}
