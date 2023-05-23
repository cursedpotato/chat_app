import 'dart:developer';

import 'package:chat_app/features/chat/models/chat_input_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    log('fingerDown', name: 'chat_input_viewmodel.dart');
    if (!state.showMicIcon) return;
    updateCanAnimate(false);
    updateInputState(ChatInputState.dismissibleAudioState);
  }

  void fingerOff(PointerEvent details) {
    log('fingerOff', name: 'chat_input_viewmodel.dart');
    if (!state.showMicIcon) return;
    if (state.inputState == ChatInputState.audioDismissedState) return;
    updateInputState(ChatInputState.defaultState);
    updateCanAnimate(true);
  }

  void updateLocation(PointerEvent details, Size screenSize) {
    updateSliderPosition(details.position.dx);

    log(
      'updateLocation: ${details.position.dx} / ${screenSize.width}',
      name: 'chat_input_viewmodel.dart',
    );

    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    if (details.position.dx < screenWidth * 0.5) {
      log('Im triggeredfinal inputCtrl = ref.watch(chatInputViewModelProvider);');
      updateInputState(ChatInputState.audioDismissedState);
    }
    if (details.position.dy < screenHeight * 0.55) {}
  }
}
