import 'dart:math';

import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/core/theme/sizes.dart';
import 'package:chat_app/features/chat/models/message_model.dart';
import 'package:chat_app/features/chat/utils/format_duration_util.dart';

import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';

import '../../../../viewmodel/audio_player_viewmodel.dart';

part 'play_button.dart';
part 'seekbar.dart';
part 'counter.dart';
part 'speed_button.dart';

class AudioMessage extends HookConsumerWidget {
  const AudioMessage(
    this.message, {
    Key? key,
  }) : super(key: key);

  final ChatMessageModel message;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String id = message.id;
    final ProcessingState processingState =
        ref.watch(audioPlayerVM(id).select((value) => value.processingState));

    useEffect(() {
      ref.read(audioPlayerVM(id).notifier).preparePlayer(message);
      return;
    }, []);

    if (processingState == ProcessingState.idle) {
      return GestureDetector(
        onTap: () {
          ref.read(audioPlayerVM(id).notifier).preparePlayer(message);
        },
        child: const SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: Icon(Icons.escalator_rounded),
          ),
        ),
      );
    }

    if (processingState == ProcessingState.loading) {
      return const SizedBox(
        height: 50,
        width: 50,
        child: Center(
          child: LinearProgressIndicator(),
        ),
      );
    }

    if (processingState == ProcessingState.buffering) {
      return const SizedBox(
        height: 50,
        width: 50,
        child: Center(
          child: LinearProgressIndicator(),
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.66,
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding * 0.4,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: kPrimaryColor.withOpacity(message.isSender ? 1 : 0.1)),
      child: Row(
        children: [
          _PlayButton(id),
          _SeekBar(id),
          _SpeedButton(id),
          _Counter(id),
        ],
      ),
    );
  }
}
