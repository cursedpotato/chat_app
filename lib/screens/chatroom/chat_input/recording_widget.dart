import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;

// Recording widget related variables
final sliderPosition = StateProvider.autoDispose((ref) => 0.0);

final showAudioWidget = StateProvider.autoDispose((ref) => false);

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
                return const [
                  PreventKeyboardClosing(),
                  AnimatedMic(),
                  AnimatedTrash(),
                ];
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

const Duration animationDuration = Duration(milliseconds: 1800);

class AnimatedMic extends HookConsumerWidget {
  const AnimatedMic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AnimationController animationController =
        useAnimationController(duration: animationDuration);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ref.read(showAudioWidget.notifier).state = false;
        ref.read(wasAudioDiscarted.notifier).state = false;
      }
    });

    double screenWidth = MediaQuery.of(context).size.width;

    useEffect(() {
      animationController.forward();
      return;
    });

    //Mic
    Animation<double> micTranslateTop;
    Animation<double> micRotationFirst;
    Animation<double> micTranslateLeftFirst;
    Animation<double> micTranslateLeftSecond;
    Animation<double> micRotationSecond;
    Animation<double> micTranslateDown;
    Animation<double> micRotationThird;
    Animation<double> micInsideTrashTranslateDown;

    micTranslateTop = Tween(begin: 0.0, end: -100.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    micRotationFirst = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.2),
      ),
    );

    micTranslateLeftFirst = Tween(begin: 0.0, end: -screenWidth * 0.39).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.35),
      ),
    );

    micTranslateLeftSecond =
        Tween(begin: 0.0, end: -screenWidth * 0.43).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.35, 0.63),
      ),
    );

    micRotationSecond = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.45),
      ),
    );

    micTranslateDown = Tween(begin: 0.0, end: 95.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.35, 0.85, curve: Curves.easeInOut),
      ),
    );

    micRotationThird = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.45, 0.70),
      ),
    );

    micInsideTrashTranslateDown = Tween(begin: 0.0, end: 60.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.9, 1.0, curve: Curves.easeInOut),
      ),
    );

    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..rotate(vmath.Vector3(1.0, 0.3, 0.0), micRotationSecond.value),
              // ..translate(micTranslateLeftFirst.value, micTranslateTop.value)
              // ..rotate(vmath.Vector3.all(0.0), micRotationSecond.value)
              // ..translate(micTranslateLeftSecond.value, micTranslateDown.value)..rotate(vmath.Vector3.all(0.0), micRotationThird.value)
              // ..translate(0.0, micInsideTrashTranslateDown.value),
            child: child,
          );
        },
        child: const SizedBox(
          width: 48,
          child: Icon(Icons.mic),
        ),
      ),
    );
  }
}

class AnimatedTrash extends HookWidget {
  const AnimatedTrash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AnimationController animationController =
        useAnimationController(duration: animationDuration);

    useEffect(
      () {
        animationController.forward();
        return;
      },
    );

    //Trash Can
    Animation<Offset> trashWithCoverTranslateTop;
    Animation<double> trashCoverRotationFirst;
    Animation<double> trashCoverTranslateLeft;
    Animation<double> trashCoverRotationSecond;
    Animation<double> trashCoverTranslateRight;
    Animation<Offset> trashWithCoverTranslateDown;

    trashWithCoverTranslateTop =
        Tween<Offset>(begin: const Offset(0.0, 60), end: const Offset(0.0, 0.0))
            .animate(
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

    trashWithCoverTranslateDown =
        Tween<Offset>(begin: const Offset(0.0, 0.0), end: const Offset(0.0, 60))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.9, 1.0),
      ),
    );

    return AnimatedBuilder(
      animation: trashWithCoverTranslateTop,
      builder: (context, child) {
        return Transform.translate(
          offset: trashWithCoverTranslateTop.value,
          child: Transform.translate(
            offset: trashWithCoverTranslateDown.value,
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          AnimatedBuilder(
            animation: trashCoverRotationFirst,
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
            padding: EdgeInsets.only(
              top: 2,
              right: 0.5,
            ),
            child: Image(
              image: AssetImage('assets/images/trash_container.png'),
              width: 30,
            ),
          ),
        ],
      ),
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
