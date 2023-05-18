import 'package:flutter/material.dart';

@immutable
class ChatInputModel {
  final double sliderPosition;
  final double stackSize;
  final bool showRecordingWidget;
  final bool showControlRec;
  final bool showMicIcon;
  final bool canAnimate;
  final PointerEvent? details;

  const ChatInputModel({
    required this.sliderPosition,
    required this.stackSize,
    required this.showRecordingWidget,
    required this.showControlRec,
    required this.showMicIcon,
    required this.canAnimate,
    required this.details,
  });

  // create copywith method
  ChatInputModel copyWith({
    double? sliderPosition,
    double? stackSize,
    bool? showRecordingWidget,
    bool? showControlRec,
    bool? showMicIcon,
    bool? canAnimate,
    PointerEvent? details,
  }) {
    return ChatInputModel(
      sliderPosition: sliderPosition ?? this.sliderPosition,
      stackSize: stackSize ?? this.stackSize,
      showRecordingWidget: showRecordingWidget ?? this.showRecordingWidget,
      showControlRec: showControlRec ?? this.showControlRec,
      showMicIcon: showMicIcon ?? this.showMicIcon,
      canAnimate: canAnimate ?? this.canAnimate,
      details: details ?? this.details,
    );
  }
}
