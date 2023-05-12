import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/fonts.dart';
import '../../../../utils/gallery_display_text_function.dart';

class CountImagesWidget extends StatelessWidget {
  const CountImagesWidget({
    Key? key,
    required this.imagesCount,
    required this.size,
    required this.image,
  }) : super(key: key);

  final int imagesCount;
  final double size;
  final String? image;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * size;
    return SizedBox(
      width: screenWidth,
      height: screenWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _BlurryImage(
            image: image,
            size: size,
          ),
          _imageNumber(),
        ],
      ),
    );
  }

  Align _imageNumber() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        displayText(imagesCount),
        style: displayMediumInter,
      ),
    );
  }
}

class _BlurryImage extends StatelessWidget {
  const _BlurryImage({
    Key? key,
    required this.image,
    required this.size,
  }) : super(key: key);

  final String? image;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Builder(builder: (context) {
        if (image == null) {
          return const CircularProgressIndicator(
            color: Colors.white,
          );
        }
        return ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Image(
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width * size,
            height: MediaQuery.of(context).size.width * size,
            image: CachedNetworkImageProvider(
              image!,
            ),
          ),
        );
      }),
    );
  }
}
