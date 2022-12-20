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

    ValueNotifier<bool> showMenu = useState(false);
    late final menuAnimationController =
        useAnimationController(duration: duration);
    //---------------------------------
    // Show row icons related variables
    //---------------------------------
    late final Animation<Offset> rowAnimation = Tween<Offset>(
      begin: const Offset(-2.75, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: menuAnimationController,
      curve: Curves.decelerate,
    ));

    if (showMenu.value) menuAnimationController.forward();
    if (!showMenu.value) menuAnimationController.reverse();

    //--------------------------
    // Overlay related variables
    //--------------------------
    List animation = [];
    GlobalKey globalKey = GlobalKey();

    final overlayState = useState(Overlay.of(context));

    List<Widget> columnButtons = [
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.attach_file),
      ),
    ];

    useEffect(() {
      for (int i = columnButtons.length; i > 0; i--) {
        animation.add(Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: menuAnimationController,
            curve: Interval(0.2 * i, 1.0, curve: Curves.ease))));
      }
      return;
    }, []);

    Future<void> showOverlayItems() async {
      RenderBox? renderBox =
          globalKey.currentContext!.findRenderObject() as RenderBox?;
      Offset position = renderBox!.localToGlobal(Offset.zero);
      Size size = renderBox.size;

      final overlayEntry = OverlayEntry(
        builder: (context) {
          return Positioned(
            left: position.dx,
            top: position.dy - size.height * 1.25,
            width: size.width,
            child: Card(
              borderOnForeground: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < columnButtons.length; i++)
                    ScaleTransition(
                      scale: animation[i],
                      child: columnButtons[i],
                    )
                ],
              ),
            ),
          );
        },
      );

      menuAnimationController.addListener(() {
        overlayState.value;
      });
      menuAnimationController.forward();
      overlayState.value!.insert(overlayEntry);

      await Future.delayed(const Duration(seconds: 5))
          .whenComplete(() => menuAnimationController.reverse())
          .whenComplete(() => overlayEntry.remove());
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
                    position: rowAnimation,
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
                    position: rowAnimation,
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
