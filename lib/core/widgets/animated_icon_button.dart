import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:math' as math;

class AnimatedIconButton extends HookWidget {
  const AnimatedIconButton(
      {Key? key,
      required this.startIcon,
      required this.endIcon,
      required this.onTap,
      required this.animationController})
      : super(key: key);

  final IconData startIcon;
  final IconData endIcon;
  final VoidCallback onTap;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    double x = 0;
    double y = 1.0;
    animationController.addListener(() {
      x = animationController.value;
      y = 1.0 - animationController.value;
    });

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Transform.rotate(
                    angle: -(math.pi / 180 * (180 * x)),
                    child: Opacity(opacity: y, child: child));
              },
              child: Icon(
                startIcon,
                size: 24.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: math.pi / 180 * (180 * y),
                  child: Opacity(opacity: x, child: child),
                );
              },
              child: Icon(
                endIcon,
                size: 24.0,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
