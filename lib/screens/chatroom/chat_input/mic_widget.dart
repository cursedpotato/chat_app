
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sound/flutter_sound.dart';




class MicWidget extends StatefulWidget {
  const MicWidget({Key? key}) : super(key: key);

  @override
  State<MicWidget> createState() => _MicWidgetState();
}

class _MicWidgetState extends State<MicWidget> {
  FocusNode focusNode = FocusNode();

  FlutterSoundRecorder? recorder;

  bool isRecorderReady = false;
  Future initRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) throw RecordingPermissionException('Microphone permission not granted');
    recorder = FlutterSoundRecorder();
    await recorder!.openRecorder();
  }


  @override
  void initState() {
    super.initState();
    initRecorder().then((value) {
      recorder!.setSubscriptionDuration(const Duration(milliseconds: 400));
      setState(() {
        isRecorderReady = true;
      });
    });
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRect(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [Icon(Icons.mic), Text('0:01')],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
