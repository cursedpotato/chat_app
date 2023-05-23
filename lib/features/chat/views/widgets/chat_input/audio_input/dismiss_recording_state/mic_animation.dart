part of 'dissmiss_recording_animation_widget.dart';

class _AnimatedMic extends HookConsumerWidget {
  const _AnimatedMic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AnimationController animationController =
        useAnimationController(duration: animationDuration);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final inputCtrl = ref.read(chatInputViewModelProvider.notifier);
        inputCtrl.updateShowRecordingWidget(false);
        inputCtrl.updateWasRecordingDismissed(false);
      }
    });

    late final double screenWidth = MediaQuery.of(context).size.width * 0.9;

    useEffect(() {
      animationController.forward();
      return;
    });

    //Mic
    late final Animation<double> micRotation;
    late final Animation<double> micTranslateTop;
    late final Animation<double> micTranslateLeftFirst;
    late final Animation<double> micTranslateDown;
    late final Animation<double> micTranslateLeftSecond;
    late final Animation<double> micInsideTrashTranslateDown;

    micRotation = useMemoized(
      () => Tween(begin: 0.0, end: pi * 3).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.0, 0.70),
        ),
      ),
    );

    micTranslateTop = useMemoized(
      () => Tween(begin: 0.0, end: -100.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
        ),
      ),
    );

    micTranslateLeftFirst = useMemoized(
      () => Tween(begin: 0.0, end: -screenWidth * 0.4635).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.0, 0.35),
        ),
      ),
    );

    micTranslateDown = useMemoized(
      () => Tween(begin: 0.0, end: 95.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.35, 0.85, curve: Curves.easeInOut),
        ),
      ),
    );

    micTranslateLeftSecond = useMemoized(
      () => Tween(begin: 0.0, end: -screenWidth * 0.4635).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.35, 0.63),
        ),
      ),
    );

    micInsideTrashTranslateDown = useMemoized(
      () => Tween(begin: 0.0, end: 60.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.9, 1.0, curve: Curves.easeInOut),
        ),
      ),
    );

    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..translate(micTranslateLeftFirst.value, micTranslateTop.value)
              ..translate(micTranslateLeftSecond.value, micTranslateDown.value)
              ..translate(0.0, micInsideTrashTranslateDown.value),
            child: Transform.rotate(
              angle: micRotation.value,
              child: child,
            ),
          );
        },
        child: const SizedBox(
          height: 48,
          child: Icon(Icons.mic),
        ),
      ),
    );
  }
}
