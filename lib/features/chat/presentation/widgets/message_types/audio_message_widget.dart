import 'dart:math';

import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../globals.dart';

import 'dart:io';

class AudioMessage extends HookWidget {
  const AudioMessage(
    this.message, {
    Key? key,
  }) : super(key: key);

  final ChatMesssageModel message;
  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();

    preparePlayer() async {
      try {
        final path = await getTemporaryDirectory();
        final fullPath = '${path.path}/${message.id}';
        bool hasFile = (await File(fullPath).exists());

        if (!hasFile) {
          debugPrint("Downloading audio file");
          final response = await Dio().download(message.resUrls![0], fullPath);
          if (response.statusMessage == "OK") {
            await player.setFilePath(fullPath);
          }
        }
        await player.setFilePath(fullPath);
      } catch (e) {
        debugPrint("Error loading audio source: $e");
      }
    }

    // Release the player's resources when not in use. We use "stop" so that
    // if the app resumes later, it will still remember what position to
    // resume from.
    final appState = useAppLifecycleState();
    if (appState == AppLifecycleState.paused) player.stop();
    if (appState == AppLifecycleState.detached ||
        appState == AppLifecycleState.inactive) {
      player.dispose();
    }
    useEffect(() {
      preparePlayer();
      return () => player.stop();
    }, [appState == AppLifecycleState.resumed]);

    return Container(
      width: MediaQuery.of(context).size.width * 0.66,
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
          SeekBar(audioPlayer: player),
          SpeedButton(audioPlayer: player),
          // Counter(audioPlayer: player),
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

class SeekBar extends HookWidget {
  const SeekBar({Key? key, required this.audioPlayer}) : super(key: key);

  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.33;

    final state = useStream(audioPlayer.playerStateStream);
    final duration = useStream(audioPlayer.durationStream).data?.inMilliseconds;
    final position = useStream(audioPlayer.positionStream).data?.inMilliseconds;

    if (!state.hasData) return const SizedBox();

    bool isNull = position == null || duration == null;
    // We use the ternary operator because the position sometimes can be greater
    // than the duration and that leads to divisions between zero
    double percentage = isNull
        ? 0.0
        : ((position > duration ? duration : position * 100.0) / duration) /
            100;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 1,
          width: width,
          color: Colors.black,
        ),
        Transform.translate(
          offset: Offset(-width / 2 + width * percentage, 0.0),
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50)),
          ),
        ),
      ],
    );
  }
}

class AudioWaveformWidget extends StatelessWidget {
  final Color waveColor;
  final double scale;
  final double strokeWidth;
  final double pixelsPerStep;
  final Waveform waveform;
  final Duration start;
  final Duration duration;

  const AudioWaveformWidget({
    Key? key,
    required this.waveform,
    required this.start,
    required this.duration,
    this.waveColor = Colors.blue,
    this.scale = 1.0,
    this.strokeWidth = 5.0,
    this.pixelsPerStep = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(
        painter: AudioWaveformPainter(
          waveColor: waveColor,
          waveform: waveform,
          start: start,
          duration: duration,
          scale: scale,
          strokeWidth: strokeWidth,
          pixelsPerStep: pixelsPerStep,
        ),
      ),
    );
  }
}

class AudioWaveformPainter extends CustomPainter {
  final double scale;
  final double strokeWidth;
  final double pixelsPerStep;
  final Paint wavePaint;
  final Waveform waveform;
  final Duration start;
  final Duration duration;

  AudioWaveformPainter({
    required this.waveform,
    required this.start,
    required this.duration,
    Color waveColor = Colors.blue,
    this.scale = 1.0,
    this.strokeWidth = 5.0,
    this.pixelsPerStep = 8.0,
  }) : wavePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..color = waveColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (duration == Duration.zero) return;

    double width = size.width;
    double height = size.height;

    final waveformPixelsPerWindow = waveform.positionToPixel(duration).toInt();
    final waveformPixelsPerDevicePixel = waveformPixelsPerWindow / width;
    final waveformPixelsPerStep = waveformPixelsPerDevicePixel * pixelsPerStep;
    final sampleOffset = waveform.positionToPixel(start);
    final sampleStart = -sampleOffset % waveformPixelsPerStep;
    for (var i = sampleStart.toDouble();
        i <= waveformPixelsPerWindow + 1.0;
        i += waveformPixelsPerStep) {
      final sampleIdx = (sampleOffset + i).toInt();
      final x = i / waveformPixelsPerDevicePixel;
      final minY = normalise(waveform.getPixelMin(sampleIdx), height);
      final maxY = normalise(waveform.getPixelMax(sampleIdx), height);
      canvas.drawLine(
        Offset(x + strokeWidth / 2, max(strokeWidth * 0.75, minY)),
        Offset(x + strokeWidth / 2, min(height - strokeWidth * 0.75, maxY)),
        wavePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AudioWaveformPainter oldDelegate) {
    return false;
  }

  double normalise(int s, double height) {
    if (waveform.flags == 0) {
      final y = 32768 + (scale * s).clamp(-32768.0, 32767.0).toDouble();
      return height - 1 - y * height / 65536;
    } else {
      final y = 128 + (scale * s).clamp(-128.0, 127.0).toDouble();
      return height - 1 - y * height / 256;
    }
  }
}

class Counter extends HookWidget {
  const Counter({Key? key, required this.audioPlayer}) : super(key: key);
  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    final bool isPlaying =
        useStream(audioPlayer.playerStateStream).data?.playing ?? false;

    final durationSnapshot = useStream(audioPlayer.durationStream);

    final positionSnapshot = useStream(audioPlayer.positionStream);

    if (!durationSnapshot.hasData) return const Text('0:00');

    timeFormat(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String seconds = twoDigits(duration.inSeconds.remainder(60));
      String minutes = duration.inMinutes.toString();
      final map = {'seconds': seconds, 'minutes': minutes};
      return map;
    }

    ValueNotifier<Map> time = useState(timeFormat(durationSnapshot.data!));

    if (isPlaying) time.value = timeFormat(positionSnapshot.data!);

    return Text('${time.value["minutes"]}:${time.value["seconds"]}');
  }
}

class SpeedButton extends HookWidget {
  const SpeedButton({
    Key? key,
    required this.audioPlayer,
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    final speedSnapshot = useStream(audioPlayer.speedStream);

    if (!speedSnapshot.hasData) return const Text("1.0");

    final speedValue = speedSnapshot.data;

    return SizedBox(
      height: 20,
      width: 20,
      child: ElevatedButton(
        onPressed: () {
          if (speedValue == 1.0) audioPlayer.setSpeed(1.25);
          if (speedValue == 1.25) audioPlayer.setSpeed(1.50);
          if (speedValue == 1.5) audioPlayer.setSpeed(1.0);
        },
        child: Text('$speedValue'),
      ),
    );
  }
}
