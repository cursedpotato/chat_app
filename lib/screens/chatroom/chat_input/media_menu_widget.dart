import 'dart:io';

import 'package:animate_icons/animate_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MediaMenu extends HookWidget {
  const MediaMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 500);
    ValueNotifier<bool> showMenu = useState(false);
    late final animationController = useAnimationController(duration: duration);
    late final Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: const Offset(-2.75, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.decelerate,
    ));

    if (showMenu.value) animationController.forward();
    if (!showMenu.value) animationController.reverse();

    final controller = AnimateIconController();
    final isMounted = useIsMounted()();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimateIcons(
          duration: duration,
          startIcon: Icons.arrow_forward_ios_rounded,
          endIcon: Icons.apps_rounded,
          onStartIconPress: () {
            showMenu.value = !showMenu.value;
            return true;
          },
          onEndIconPress: () {
            showMenu.value = !showMenu.value;
            return true;
          },
          controller: controller,
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
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();
                          if (result != null) {
                            File file = File(result.files.single.path!);
                          } else {
                            // User canceled the picker
                          }
                        },
                        icon: const Icon(Icons.attach_file)),
                  ),
                ),
                Flexible(
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: IconButton(
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(
                                  allowMultiple: true, type: FileType.media);

                          if (result == null) return;
                          List<File> files =
                              result.paths.map((path) => File(path!)).toList();
                          navigator.push(MaterialPageRoute(
                            builder: (_) => ImagePreview(imageFileList: files),
                          ));
                        },
                        icon: const Icon(Icons.filter_outlined)),
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

class ImagePreview extends StatelessWidget {
  const ImagePreview({Key? key, required this.imageFileList}) : super(key: key);

  final List<File> imageFileList;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PhotoViewGallery.builder(
          itemCount: imageFileList.length,
          builder: (_, index) {
            return PhotoViewGalleryPageOptions(
              initialScale: PhotoViewComputedScale.contained * 0.8,
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 1.1,
              imageProvider: FileImage(imageFileList[index]),
            );
          },
          loadingBuilder: (_, __) => const Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    );
  }
}
