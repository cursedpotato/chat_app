import 'package:chat_app/models/message_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:just_audio/just_audio.dart';

import '../../../globals.dart';

class AudioMessage extends HookWidget {
  final ChatMesssageModel message;
  const AudioMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPlaying = useState(false);
    final player = AudioPlayer();

    preparePlayer() async => await player.setUrl(message.resUrl!);

    useEffect(
      () {
        preparePlayer();
        return () {};
      },
    );

    playPlayer() async {
      await player.play();
    }
    pausePlayer() async {
      await player.pause();
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      margin: const EdgeInsets.only(top: kDefaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding / 2.5,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: kPrimaryColor.withOpacity(message.isSender! ? 1 : 0.1)),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              playPlayer();
              if (isPlaying.value) pausePlayer();
              isPlaying.value = !isPlaying.value;
            },
            icon: Icon(
              isPlaying.value ? Icons.pause : Icons.play_arrow,
              color: message.isSender! ? Colors.white : kPrimaryColor,
            ),
          ),
          Text(
            "0:37",
            style: TextStyle(
              fontSize: 12,
              color: message.isSender! ? Colors.white : null,
            ),
          )
        ],
      ),
    );
  }
}
