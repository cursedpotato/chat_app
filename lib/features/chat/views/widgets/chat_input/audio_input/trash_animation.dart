import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AnimatedTrash extends HookWidget {
  const AnimatedTrash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AnimationController animationController =
        // TODO: make duration a provider
        useAnimationController(duration: const Duration(milliseconds: 1800));

    useEffect(
      () {
        animationController.forward();
        return;
      },
    );

    //Trash Can
    late final Animation<double> trashWithCoverTranslateTop;
    late final Animation<double> trashCoverRotationFirst;
    late final Animation<double> trashCoverTranslateLeft;
    late final Animation<double> trashCoverRotationSecond;
    late final Animation<double> trashCoverTranslateRight;
    late final Animation<double> trashWithCoverTranslateDown;

    trashWithCoverTranslateTop = useMemoized(
      () => Tween(begin: 60.0, end: 0.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.0, 0.45),
        ),
      ),
    );

    trashCoverRotationFirst = useMemoized(
      () => Tween(begin: 0.0, end: -pi / 3).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.45, 0.55),
        ),
      ),
    );

    trashCoverTranslateLeft = useMemoized(
      () => Tween(begin: 0.0, end: -18.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.45, 0.55),
        ),
      ),
    );

    trashCoverRotationSecond = useMemoized(
      () => Tween(begin: 0.0, end: pi / 3).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.65, 0.75),
        ),
      ),
    );

    trashCoverTranslateRight = useMemoized(
      () => Tween(begin: 0.0, end: 18.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.65, 0.75),
        ),
      ),
    );

    trashWithCoverTranslateDown = useMemoized(
      () => Tween(begin: 0.0, end: 60.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.9, 1.0),
        ),
      ),
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: 48,
        child: AnimatedBuilder(
          animation: trashWithCoverTranslateTop,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..translate(0.0, trashWithCoverTranslateTop.value)
                ..translate(0.0, trashWithCoverTranslateDown.value),
              child: child,
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
        ),
      ),
    );
  }
}
