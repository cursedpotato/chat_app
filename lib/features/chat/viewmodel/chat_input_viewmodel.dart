import 'dart:developer';

import 'package:chat_app/features/chat/models/chat_input_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const initialState = ChatInputModel(
  sliderPosition: 0.0,
  stackSize: 0.0,
  wasRecoringDismissed: false,
  showRecordingWidget: false,
  showControlRec: false,
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

  void updateWasRecordingDismissed(bool value) {
    state = state.copyWith(wasRecoringDismissed: value);
  }

  void updateShowRecordingWidget(bool value) {
    state = state.copyWith(showRecordingWidget: value);
  }

  void updateShowControlRec(bool value) {
    state = state.copyWith(showControlRec: value);
  }

  void updateShowMicIcon(bool value) {
    state = state.copyWith(showMicIcon: value);
  }

  void updateCanAnimate(bool value) {
    state = state.copyWith(canAnimate: value);
  }

  void fingerDown(PointerEvent details) {
    log('fingerDown', name: 'chat_input_viewmodel.dart');
    if (!state.showMicIcon) return;
    updateShowRecordingWidget(true);
    updateCanAnimate(false);
  }

  void fingerOff(PointerEvent details) {
    log('fingerOff', name: 'chat_input_viewmodel.dart');
    if (!state.showMicIcon) return;
    // If the animation is in progress we don't want to show everything else yet
    if (!state.wasRecoringDismissed) return;
    updateShowRecordingWidget(false);
    updateCanAnimate(true);
  }

  void updateLocation(PointerEvent details, Size screenSize) {
    updateSliderPosition(details.position.dx);

    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    if (details.position.dx < screenWidth * 0.5) {
      // ref.read(recController.notifier).state.stop();
      updateWasRecordingDismissed(true);
    }
    // If position.dy is greater than 0.25 of screenHeight, we want to toggle the the playable recording widget
    if (details.position.dy < screenHeight * 0.55) {}
  }
}
