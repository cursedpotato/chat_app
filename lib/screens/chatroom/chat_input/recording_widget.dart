

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/screens/chatroom/chat_input/chat_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Do necessary implementations for iOS for flutter sound
class RecordingWidget extends HookWidget {
  const RecordingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();

    AnimationController opacityController =
        useAnimationController(duration: const Duration(milliseconds: 800))
          ..repeat(reverse: true);

    useEffect(() {
      focusNode.requestFocus();
      return () {
        focusNode.dispose();
      };
    });

    return Expanded(
      child: SizedBox(
        height: 48,
        child: Stack(
          children: [
            const Slidable(),
            Container(
              color: Colors.white,
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
                  SizedBox(
                    width: 10,
                    child: TextField(
                      focusNode: focusNode,
                      showCursor: false,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const Flexible(child: Text('0:01')),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Slidable extends ConsumerWidget {
  const Slidable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // References
    late final double pointerPosition = ref.watch(sliderPosition);
    late final double screenWidth = MediaQuery.of(context).size.width;
    late final double centerPosition = screenWidth * 0.333;
    /* We use a ternary operator because
     the pointer gives 0 at the beggining and only 
     the screenWidth remains which makes the widget go offscreen,
     therefore I chose to give a zero 
     value first so the offset doesn't get the widget out of screen */
    late final double offset = (pointerPosition == 0.0 ? 0.0 : pointerPosition - screenWidth).abs()/2;
    late final double opacity = (pointerPosition == 0.0 ? 1.0: (pointerPosition / screenWidth) - offset * 0.005);

    const colorizeColors = [
      Colors.black,
      Colors.grey,
    ];


    return Transform.translate(
      offset: Offset(centerPosition - offset, 0),
      child: Opacity(
        // If opacity is less than zero return zero
        opacity: opacity < 0 ? 0.0: opacity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedTextKit(repeatForever: true, animatedTexts: [
              ColorizeAnimatedText('slide to cancel',
                  textStyle: Theme.of(context).textTheme.bodyMedium!,
                  colors: colorizeColors)
            ]),
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
