import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_provider/path_provider.dart';

import '../../../globals.dart';

class AudioMessage extends HookWidget {
  final ChatMesssageModel message;
  const AudioMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPlaying = useState(false);
    late PlayerController playerController = PlayerController();

    preparePlayer() async {
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/${message.id}';
      final url = message.resUrl!;
      await Dio().download(url, path);
      await playerController.preparePlayer(path);
    }

    void playOrPausePlayer(PlayerController controller) async {
      controller.playerState == PlayerState.playing
          ? await controller.pausePlayer()
          : await controller.startPlayer(finishMode: FinishMode.pause);
    }

    useEffect(() {
      playerController = PlayerController();
      preparePlayer();
      return ;
    },);

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
              isPlaying.value = !isPlaying.value;
              playOrPausePlayer(playerController);
            },
            icon: Icon(
              isPlaying.value ? Icons.pause : Icons.play_arrow,
              color: message.isSender! ? Colors.white : kPrimaryColor,
            ),
          ),
          AudioFileWaveforms(
            size: Size(MediaQuery.of(context).size.width / 4, 70),
            playerController: playerController,
            density: 1.5,
            playerWaveStyle: const PlayerWaveStyle(
              scaleFactor: 0.8,
              fixedWaveColor: Colors.white30,
              liveWaveColor: Colors.white,
              waveCap: StrokeCap.butt,
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
