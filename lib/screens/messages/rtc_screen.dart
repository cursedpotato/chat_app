import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class VideoCallScreen extends HookWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AgoraClient _client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: '',
        channelName: "",
        tempToken: "",
      ),
    );
    Future<void> _initAgora() async {
      await _client.initialize();
    }

    useEffect(() {
      _initAgora();
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
              AgoraVideoViewer(client: _client),
              AgoraVideoButtons(client: _client)
            ],
          ),
        ),
      ),
    );
  }
}
