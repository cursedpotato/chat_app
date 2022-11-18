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
    final player = AudioPlayer();

    preparePlayer() async {
      try {
        await player.setUrl(message.resUrl!);
      } catch (e) {
        print("Error loading audio source: $e");
      }
    }

    // Release the player's resources when not in use. We use "stop" so that
    // if the app resumes later, it will still remember what position to
    // resume from.
    final appState = useAppLifecycleState();
    if (appState == AppLifecycleState.paused) player.stop();
    if (appState == AppLifecycleState.detached ||
        appState == AppLifecycleState.inactive) player.dispose();
    useEffect(() {
      preparePlayer();
      return () => player.stop();
    }, [appState == AppLifecycleState.resumed]);

    return Container(
      width: MediaQuery.of(context).size.width * 0.60,
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding * 0.4,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: kPrimaryColor.withOpacity(message.isSender! ? 1 : 0.1)),
      child: Row(
        children: [
          PlayButton(audioPlayer: player),
          Counter(audioPlayer: player),
        ],
      ),
    );
  }
}

class PlayButton extends HookWidget {
  const PlayButton({Key? key, required this.audioPlayer}) : super(key: key);

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    final playerIcon = useState(Icons.play_arrow);

    final stateSnapshot = useStream(audioPlayer.playerStateStream);

    final processingState = stateSnapshot.data?.processingState;

    final isLoading = processingState == ProcessingState.buffering ||
        processingState == ProcessingState.loading ||
        !stateSnapshot.hasData;
    final isCompleted = processingState == ProcessingState.completed;

    if (isLoading) {
      return IconButton(onPressed: () {}, icon: Icon(playerIcon.value));
    }
    // To listen to the audio again when finished
    if (isCompleted) {
      audioPlayer.seek(Duration.zero);
      audioPlayer.pause();
    }

    final isPlaying = stateSnapshot.requireData.playing;
    return IconButton(
      icon: Icon(
        isPlaying
            ? playerIcon.value = Icons.pause
            : playerIcon.value = Icons.play_arrow,
      ),
      onPressed: () => isPlaying ? audioPlayer.pause() : audioPlayer.play(),
    );
  }
}



class Counter extends HookWidget {
  const Counter({Key? key, required this.audioPlayer}) : super(key: key);
  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    final bool isPlaying = useStream(audioPlayer.playerStateStream).data?.playing ?? false;

    final durationSnapshot = useStream(audioPlayer.durationStream);

    final positionSnapshot = useStream(audioPlayer.positionStream);


    if (!durationSnapshot.hasData) return const SizedBox();

    timeFormat(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String seconds = twoDigits(duration.inSeconds.remainder(60));
      String minutes = duration.inMinutes.toString();
      final map = {
        'seconds' : seconds,
        'minutes' : minutes
      };
      return map;
    }

    ValueNotifier<Map> time = useState(timeFormat(durationSnapshot.data!));

    if (isPlaying) time.value = timeFormat(positionSnapshot.data!) ;

    return Text('${time.value["minutes"]}:${time.value["seconds"]}');
  }
}
