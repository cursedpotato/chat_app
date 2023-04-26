import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class VideoCallScreen extends HookWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AgoraClient client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: '',
        channelName: "",
        tempToken: "",
      ),
    );
    Future<void> initAgora() async {
      await client.initialize();
    }

    useEffect(() {
      initAgora();
      return () {};
    });
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Hello world"),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(client: client),
              AgoraVideoButtons(client: client)
            ],
          ),
        ),
      ),
    );
  }
}
