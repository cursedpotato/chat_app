import 'dart:developer';

import 'package:chat_app/features/chat/models/chat_input_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'recording_viewmodel.dart';

const initialState = ChatInputModel(
  sliderPosition: 0.0,
  stackSize: 0.0,
  inputState: ChatInputState.defaultState,
  showMicIcon: false,
  canButtonAnimate: false,
  details: null,
);

final chatInputViewModelProvider =
    StateNotifierProvider.autoDispose<ChatInputViewModel, ChatInputModel>(
  (ref) => ChatInputViewModel(ref),
);

class ChatInputViewModel extends StateNotifier<ChatInputModel> {
  Ref ref;

  ChatInputViewModel(this.ref) : super(initialState);

  void updateSliderPosition(double value) {
    state = state.copyWith(sliderPosition: value);
  }

  void updateStackSize(double value) {
    state = state.copyWith(stackSize: value);
  }

  void updateInputState(ChatInputState value) {
    state = state.copyWith(inputState: value);
  }

  void updateShowMicIcon(bool value) {
    state = state.copyWith(showMicIcon: value);
  }

  void updateCanAnimate(bool value) {
    state = state.copyWith(canAnimate: value);
  }

  void fingerDown(PointerEvent details) {
    if (!state.showMicIcon) return;
    updateCanAnimate(false);
    ref.read(recorderViewModelProvider.notifier).startRecording().then((value) {
      updateInputState(ChatInputState.dismissibleAudioState);
    });
  }

  void fingerOff(PointerEvent details) {
    if (!state.showMicIcon) return;
    if (state.inputState == ChatInputState.audioDismissedState) return;
    if (state.inputState == ChatInputState.controlRecordingState) return;

    ref.read(recorderViewModelProvider.notifier).stopRecording().then((value) {
      updateInputState(ChatInputState.defaultState);
    });
    updateCanAnimate(true);
  }

  void updateLocation(PointerEvent details, Size screenSize) {
    updateSliderPosition(details.position.dx);

    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    if (details.position.dx < screenWidth * 0.5) {
      updateInputState(ChatInputState.audioDismissedState);
    }
    if (details.position.dy < screenHeight * 0.55) {
      updateInputState(ChatInputState.controlRecordingState);
    }
  }
}
