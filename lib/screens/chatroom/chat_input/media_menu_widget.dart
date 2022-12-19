import 'dart:io';

import 'package:animate_icons/animate_icons.dart';
import 'package:chat_app/screens/chatroom/chat_input/camera_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'media_preview_widget.dart';

class MediaMenu extends HookWidget {
  const MediaMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 500);
    //---------------------------------
    // Show row icons related variables
    //---------------------------------
    ValueNotifier<bool> showMenu = useState(false);
    late final menuIconAnimationController =
        useAnimationController(duration: duration);
    late final Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: const Offset(-2.75, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: menuIconAnimationController,
      curve: Curves.decelerate,
    ));

    if (showMenu.value) menuIconAnimationController.forward();
    if (!showMenu.value) menuIconAnimationController.reverse();

    //--------------------------
    // Overlay related variables
    //--------------------------

    GlobalKey globalKey = GlobalKey();

    void showOverlayItems() {
      final overlayState = Overlay.of(context);

      

      RenderBox? renderBox =
          globalKey.currentContext!.findRenderObject() as RenderBox?;
      Offset position = renderBox!.localToGlobal(Offset.zero);
      Size size = renderBox.size;


      final overlayEntry = OverlayEntry(
        builder: (context) {
          return Positioned(
            left: position.dx,
            top: position.dy - size.height,
            width: size.width,
            child: Card(
              borderOnForeground: false,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.attach_file,
                  color: Colors.red,
                  size: 24,
                ),
              ),
            ),
          );
        },
      );

      if (showMenu.value == true) {
        print("Opening overlay");
        overlayState!.insert(overlayEntry);
      }

      if (showMenu.value == false) {
        print("Closing overlay");
        overlayState!.deactivate();
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          key: globalKey,
          child: AnimateIcons(
            duration: duration,
            startIcon: Icons.arrow_forward_ios_rounded,
            endIcon: Icons.apps_rounded,
            onStartIconPress: () {
              
              showMenu.value = !showMenu.value;
              showOverlayItems();
              return true;
            },
            onEndIconPress: () {
              showMenu.value = !showMenu.value;
              showOverlayItems();
              return true;
            },
            controller: AnimateIconController(),
          ),
        ),

        // This prevents the animated container from overflowing
        AnimatedContainer(
          height: 48,
          width: showMenu.value ? 104 : 0.0,
          duration: duration,
          curve: showMenu.value ? Curves.elasticOut : Curves.ease,
          child: ClipRect(
            child: Row(
              children: [
                Flexible(
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: IconButton(
                      onPressed: () async {
                        // We initialize a navigator here because this way,
                        // we handle that flutter doesn't run any code
                        // in an async gap where we don't know if the user has picked any files
                        final navigator = Navigator.of(context);
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.media,
                        );

                        if (result == null) return;
                        List<File> files =
                            result.paths.map((path) => File(path!)).toList();
                        navigator.push(MaterialPageRoute(
                          builder: (_) => ImagePreview(imageFileList: files),
                        ));
                      },
                      icon: const Icon(Icons.filter_outlined),
                    ),
                  ),
                ),
                Flexible(
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: IconButton(
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CameraExampleHome(),
                          ));
                        },
                        icon: const Icon(Icons.camera_alt_outlined)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
