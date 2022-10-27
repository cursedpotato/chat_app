import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Recording widget related variables
final sliderPosition = StateProvider.autoDispose((ref) => 0.0);
final showAudioWidgetProvider = StateProvider.autoDispose((ref) => false);
final wasAudioDiscarted = StateProvider.autoDispose((ref) => false);

// TODO: Do necessary implementations for iOS for flutter sound
class RecordingWidget extends HookWidget {
  const RecordingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 48,
        child: Consumer(
          builder: (context, ref, child) {
            List<Widget> stackList() {
              if (ref.watch(wasAudioDiscarted)) {
                return const [AnimatedTrash(), PreventKeyboardClosing()];
              }
              return const [
                Slidable(),
                RecordingCounter(),
                PreventKeyboardClosing()
              ];
            }

            return Stack(children: stackList());
          },
        ),
      ),
    );
  }
}

// Flutter hasn't implemented yet the option to open the keyboard without the need of a textfield
class PreventKeyboardClosing extends HookWidget {
  const PreventKeyboardClosing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode()..requestFocus();
    return TextField(
      focusNode: focusNode,
      showCursor: false,
      decoration: const InputDecoration(border: InputBorder.none),
    );
  }
}

class AnimatedTrash extends HookWidget {
  const AnimatedTrash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AnimationController animationController =
        useAnimationController(duration: const Duration(milliseconds: 2500));

    useEffect(
      () {
        animationController.forward();
        return;
      },
    );

    final animation = Tween(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
    );

    //Trash Can
    Animation<double> trashWithCoverTranslateTop;
    Animation<double> trashCoverRotationFirst;
    Animation<double> trashCoverTranslateLeft;
    Animation<double> trashCoverRotationSecond;
    Animation<double> trashCoverTranslateRight;
    Animation<double> trashWithCoverTranslateDown;

    trashWithCoverTranslateTop = Tween(begin: 30.0, end: -25.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.45),
      ),
    );

    trashCoverRotationFirst = Tween(begin: 0.0, end: -pi / 3).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.45, 0.55),
      ),
    );

    trashCoverTranslateLeft = Tween(begin: 0.0, end: -18.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.45, 0.55),
      ),
    );

    trashCoverRotationSecond = Tween(begin: 0.0, end: pi / 3).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.65, 0.75),
      ),
    );

    trashCoverTranslateRight = Tween(begin: 0.0, end: 18.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.65, 0.75),
      ),
    );

    trashWithCoverTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.80, 1.0),
      ),
    );

    return Consumer(
      builder: (context, ref, child) {
        animationController.addStatusListener((status) {
          print('This is the status of the animation: $status');
        });
        return Column(
          children: [
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(trashWithCoverTranslateTop.value)
                    ..translate(trashWithCoverTranslateDown.value),
                  child: child,
                );
              },
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Transform(
                        transform: Matrix4.identity()
                          ..translate(trashCoverTranslateLeft.value)
                          ..translate(trashCoverTranslateRight.value),
                        child: Transform.rotate(
                          angle: trashCoverRotationSecond.value,
                          child: Transform.rotate(
                            angle: trashCoverRotationFirst.value,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: const Image(
                      image: AssetImage('assets/images/trash_cover.png'),
                      width: 30,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Image(
                      image: AssetImage('assets/images/trash_container.png'),
                      width: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class RecordingCounter extends HookWidget {
  const RecordingCounter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We use focus node instead of autofocus, because the later doesn't work when the textfield is nested

    AnimationController opacityController =
        useAnimationController(duration: const Duration(milliseconds: 800))
          ..repeat(reverse: true);
    return Container(
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
          const SizedBox(
            width: 10,
            height: 48,
          ),
          const Flexible(child: Text('0:01')),
          const SizedBox(width: 10)
        ],
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
    late final double offset =
        (pointerPosition == 0.0 ? 0.0 : pointerPosition - screenWidth).abs() /
            2;
    late final double opacity = (pointerPosition == 0.0
        ? 1.0
        : (pointerPosition / screenWidth) - offset * 0.005);

    // We may only call this if the recording duration is more than 1 second
    if (opacity < 0) {
      // Our provider is wrapped inside a future delayed to avoid calling this over and over again in a rebuild
      Future.delayed(Duration.zero,
          () => ref.read(wasAudioDiscarted.notifier).state = true);
    }

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
