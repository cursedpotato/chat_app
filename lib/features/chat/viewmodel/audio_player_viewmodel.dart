import 'dart:io';

import 'package:chat_app/features/chat/models/audio_player_model.dart';
import 'package:chat_app/features/chat/models/media_model.dart';
import 'package:chat_app/features/chat/models/message_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

const initalState = AudioPlayerModel(
  isPlaying: false,
  duration: 0,
  position: 0,
  volume: 0.5,
  speed: 1.0,
  bufferPercentage: 0.0,
  percentage: 0.0,
  audioPlayer: null,
  processingState: ProcessingState.idle,
);

final audioPlayerVM =
    StateNotifierProvider.family<AudioPlayerNotifier, AudioPlayerModel, String>(
  (ref, id) => AudioPlayerNotifier(ref),
);

class AudioPlayerNotifier extends StateNotifier<AudioPlayerModel> {
  final Ref _ref;
  AudioPlayerNotifier(this._ref) : super(initalState) {
    // Init audio player
    state = state.copyWith(
      audioPlayer: AudioPlayer(),
    );

    final audioPlayer = state.audioPlayer;

    // Init listeners
    final processSub = audioPlayer!.playerStateStream.listen((event) {
      state = state.copyWith(
        processingState: event.processingState,
      );
    });

    final durationSub = audioPlayer.durationStream.listen((event) {
      state = state.copyWith(
        duration: event != null ? event.inMilliseconds : 0,
      );
    });

    final positionStream = audioPlayer.positionStream.listen((event) {
      state = state.copyWith(
        position: event.inMilliseconds,
        percentage: event.inMilliseconds / state.duration,
      );
    });

    // _ref.onDispose(() {
    //   audioPlayer.dispose();
    //   processSub.cancel();
    //   durationSub.cancel();
    //   positionStream.cancel();
    // });
  }

  Future<void> preparePlayer(ChatMessageModel model) async {
    final audioPlayer = state.audioPlayer;
    final media = model.mediaList.first as AudioMedia;

    final doesFileExists = await File(media.localPath).exists();

    if (model.isSender && doesFileExists) {
      await audioPlayer!.setAudioSource(AudioSource.file(media.localPath));
    }
    if (!doesFileExists) {
      await audioPlayer!.setUrl(media.mediaUrl);
    }
  }

  Future<void> togglePlay() {
    final audioPlayer = state.audioPlayer;
    if (state.isPlaying) {
      _updateIsPlaying(false);
      return audioPlayer!.pause();
    }
    _updateIsPlaying(true);
    return audioPlayer!.play();
  }

  void updateVolume(double value) {
    state = state.copyWith(volume: value);
  }

  void _updateIsPlaying(bool value) {
    state = state.copyWith(isPlaying: value);
  }

  Future<void> replay() {
    final audioPlayer = state.audioPlayer;
    return audioPlayer!.seek(const Duration(seconds: 0));
  }
}
