import 'package:camera/camera.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CameraScreen extends HookConsumerWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late CameraController controller;

    final _cameras = ref.watch(camerasList);
    useEffect(() {
      controller = CameraController(_cameras[0], ResolutionPreset.max);
      controller.initialize().then((_) {}).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              // Handle access errors here.
              break;
            default:
              // Handle other errors here.
              break;
          }
        }
      });
      return;
    }, []);
    return CameraPreview(controller);
  }
}
