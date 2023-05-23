import 'package:flutter/material.dart';

enum ChatInputState {
  defaultState,
  dismissibleAudioState,
  controlRecordingState,
  audioDismissedState
}

@immutable
class ChatInputModel {
  final double sliderPosition;
  final double stackSize;
  final bool showMicIcon;
  final bool canButtonAnimate;
  final ChatInputState inputState;
  final PointerEvent? details;

  const ChatInputModel({
    required this.sliderPosition,
    required this.stackSize,
    required this.showMicIcon,
    required this.inputState,
    required this.canButtonAnimate,
    required this.details,
  });

  // create copywith method
  ChatInputModel copyWith({
    double? sliderPosition,
    double? stackSize,
    ChatInputState? inputState,
    bool? showMicIcon,
    bool? canAnimate,
    PointerEvent? details,
  }) {
    return ChatInputModel(
      sliderPosition: sliderPosition ?? this.sliderPosition,
      stackSize: stackSize ?? this.stackSize,
      showMicIcon: showMicIcon ?? this.showMicIcon,
      inputState: inputState ?? this.inputState,
      canButtonAnimate: canAnimate ?? canButtonAnimate,
      details: details ?? this.details,
    );
  }
}
