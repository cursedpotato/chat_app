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
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.attach_file),
      ),
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.attach_file),
      ),
    ];

    Future<void> showOverlayItems() async {
      RenderBox? renderBox =
          globalKey.currentContext!.findRenderObject() as RenderBox?;
      Offset position = renderBox!.localToGlobal(Offset.zero);
      Size size = renderBox.size;

      for (int i = columnButtons.length; i > 0; i--) {
        animation.add(Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: menuAnimationController,
            curve: Interval(0.2 * i, 1.0, curve: Curves.ease))));
      }

      OverlayEntry? overlayEntry = OverlayEntry(
        builder: (context) {
          return Positioned(
            left: position.dx,
            top: position.dy - size.height * 4.25,
            width: size.width,
            child: Material(
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                borderOnForeground: false,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: columnButtons.length,
                  itemBuilder: (context, index) {
                    return ScaleTransition(
                      scale: animation[index],
                      child: columnButtons[index],
                    );
                  },
                )),
          );
        },
      );

      overlayState.value!.insert(overlayEntry);

      menuAnimationController.addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          overlayEntry?.remove();
          // We set it to null to avoid an assertion error,
          // that's why the overlayEntry variable is not final as well and is nullable as well
          overlayEntry = null;
        }
      });
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
              showOverlayItems();
              showMenu.value = !showMenu.value;
              return true;
            },
            onEndIconPress: () {
              showMenu.value = !showMenu.value;
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
