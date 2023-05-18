import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

@immutable
class RecordingModel {
  final Duration duration;
  final bool isRecording;
  final RecorderController recorderController;

  const RecordingModel({
    required this.duration,
    required this.isRecording,
    required this.recorderController,
  });

  // create copywith method
  RecordingModel copyWith({
    Duration? duration,
    bool? isRecording,
    RecorderController? recorderController,
  }) {
    return RecordingModel(
      duration: duration ?? this.duration,
      isRecording: isRecording ?? this.isRecording,
      recorderController: recorderController ?? this.recorderController,
    );
  }
}
