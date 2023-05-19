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
  canAnimate: false,
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
    if (!state.showMicIcon) return;
    updateShowRecordingWidget(true);
    updateCanAnimate(false);
    // startRecording().then((value) {
    //   updateShowControlRec(true);
    //   updateShowRecordingWidget(true);
    // });
  }

  void fingerOff(PointerEvent details) {
    // if (!showMic) return;
    //   // If the animation is in progress we don't want to show everything else yet
    //   if (ref.watch(wasAudioDiscarted)) return;
    //   ref.read(showAudioWidget.notifier).state = false;
    //   if (!ref.watch(isRecording)) return;
    //   if (!ref.watch(showControlRec)) {
    //     ref.read(isRecording.notifier).state = false;
    //   }
  }

  void updateLocation(PointerEvent details) {
    // ref.read(sliderPosition.notifier).state = details.position.dx;
    // // This conditional gives functionality to the slidable widget that is found in the recording widget file
    // if (details.position.dx < screenWidth * 0.5) {
    //   // This will stop the recorder
    //   ref.read(recController.notifier).state.stop();
    //   ref.read(isRecording.notifier).state = false;
    //   ref.read(wasAudioDiscarted.notifier).state = true;
    // }
    // // If position.dy is greater than 0.25 of screenHeight, we want to toggle the the playable recording widget
    // if (details.position.dy < screenHeight * 0.55) {
    //   ref.read(showControlRec.notifier).state = true;
    // }
  }
}
