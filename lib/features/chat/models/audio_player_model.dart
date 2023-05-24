import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

@immutable
class AudioPlayerModel {
  final bool isPlaying;
  final int duration;
  final int position;
  final double volume;
  final double speed;
  final double percentage;
  final AudioPlayer audioPlayer;
  final ProcessingState processingState;

  const AudioPlayerModel({
    required this.isPlaying,
    required this.duration,
    required this.position,
    required this.volume,
    required this.speed,
    required this.percentage,
    required this.audioPlayer,
    required this.processingState,
  });

  // create copywith method
  AudioPlayerModel copyWith({
    bool? isPlaying,
    int? duration,
    int? position,
    double? volume,
    double? speed,
    double? percentage,
    AudioPlayer? audioPlayer,
    ProcessingState? processingState,
  }) {
    return AudioPlayerModel(
      isPlaying: isPlaying ?? this.isPlaying,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      volume: volume ?? this.volume,
      speed: speed ?? this.speed,
      percentage: percentage ?? this.percentage,
      audioPlayer: audioPlayer ?? this.audioPlayer,
      processingState: processingState ?? this.processingState,
    );
  }
}
