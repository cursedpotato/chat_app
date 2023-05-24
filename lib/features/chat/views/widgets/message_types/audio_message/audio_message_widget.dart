import 'dart:math';

import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/core/theme/sizes.dart';
import 'package:chat_app/features/chat/models/message_model.dart';

import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';

part 'play_button.dart';
part 'seekbar.dart';
part 'counter.dart';
part 'speed_button.dart';

class AudioMessage extends HookWidget {
  const AudioMessage(
    this.message, {
    Key? key,
  }) : super(key: key);

  final ChatMessageModel message;
  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();

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
          _PlayButton(audioPlayer: player),
          _SeekBar(audioPlayer: player),
          _SpeedButton(audioPlayer: player),
          _Counter(audioPlayer: player),
        ],
      ),
    );
  }
}
