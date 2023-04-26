
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:math' as math;

import 'clipper_widget.dart';

class WaveWidget extends HookWidget {
  final Size size;
  final double yOffset;
  final Color color;

  const WaveWidget({
    Key? key,
    required this.size,
    required this.yOffset,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final animationController = useAnimationController(duration: const Duration(milliseconds: 5000))..repeat();
    List<Offset> wavePoints = [];
    animationController.addListener(() {
      wavePoints.clear();

            final double waveSpeed = animationController.value * 1080;
            final double fullSphere = animationController.value * math.pi * 2;
            final double normalizer = math.cos(fullSphere);
            const double waveWidth = math.pi / 270;
            const double waveHeight = 20.0;

            for (int i = 0; i <= size.width.toInt(); ++i) {
              double calc = math.sin((waveSpeed - i) * waveWidth);
              wavePoints.add(
                Offset(
                  i.toDouble(), //X
                  calc * waveHeight * normalizer + yOffset, //Y
                ),
              );
            }
    });

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        return ClipPath(
          clipper: ClipperWidget(
            waveList: wavePoints,
          ),
          child: Container(
            width: size.width,
            height: size.height,
            color: color,
          ),
        );
      },
    );
  }
  
}


