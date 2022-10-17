import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sound/flutter_sound.dart';

class MicWidget extends HookWidget {
  const MicWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    final recorder = FlutterSoundRecorder();

    Future initRecorder() async {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw 'Microphone Permission not granted';
      }

      await recorder.openRecorder();
    }

    useEffect(() {
      focusNode.requestFocus();
      initRecorder();
      return () => focusNode.dispose();
    });

    Future record() async => await recorder.startRecorder(toFile: 'audio');

    record();

    
    return Expanded(
      child: ClipRect(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: const [Icon(Icons.mic), Text('0:01')],
            ),
            Row(
              children: const [
                Text('slide to cancel'),
                Icon(Icons.arrow_back_ios_new_outlined)
              ],
            ),
            // We place this whole widget to avoid the keyboard from closing, giving the user a bad experience
            SizedBox(
              height: 0,
              width: 0,
              child: TextField(
                focusNode: focusNode,
                showCursor: false,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
