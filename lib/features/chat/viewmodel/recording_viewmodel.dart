import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chat_app/features/chat/models/message_model.dart';
import 'package:chat_app/features/chat/models/recording_model.dart';
import 'package:chat_app/features/chat/services/message_storage_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'messages_viewmodel.dart';

const initalState = RecordingModel(
  duration: Duration.zero,
  isRecording: false,
  recorderController: null,
);

class RecorderViewModel extends StateNotifier<RecordingModel> {
  final Ref _ref;
  RecorderViewModel(this._ref) : super(initalState) {
    state = state.copyWith(
      recorderController: RecorderController(),
    );

    final recorderController = state.recorderController;
    // Init config
    recorderController!
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;

    // Init listeners
    final sub = recorderController.onCurrentDuration.listen((event) {
      state = state.copyWith(
        duration: event,
      );
    });

    _ref.onDispose(() {
      state.recorderController!.dispose();
      sub.cancel();
    });
  }

  void startRecording() async {
    await state.recorderController!.record();
    state = state.copyWith(
      isRecording: true,
    );
  }

  void pauseRecording() async {
    await state.recorderController!.pause();
    state = state.copyWith(
      isRecording: false,
    );
  }

  void stopRecording() async {
    final messageId = const Uuid().v1();
    final filePath = await state.recorderController!.stop();

    state = state.copyWith(
      isRecording: false,
    );

    if (filePath == null || filePath.isEmpty) return;

    final audioUrl =
        await MessageStorageServices().uploadFileToStorage(filePath, messageId);

    FirebaseStorage.instance
        .refFromURL(audioUrl)
        .updateMetadata(SettableMetadata(
          contentType: "audio/m4a",
        ));

    final message =
        ChatMessageModel.audioMessage(id: messageId, audioUrl: audioUrl);

    _ref.read(messagesViewModelProvider.notifier).uploadMessage(message);
  }
}
