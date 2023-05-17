import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RoundedCornerWidget extends StatelessWidget {
  const RoundedCornerWidget({
    super.key,
    required this.image,
  });

  final String? image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Builder(builder: (context) {
          if (image == null) {
            return const CircularProgressIndicator(
              color: Colors.white,
            );
          }

          return Image(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(image!),
          );
        }),
      ),
    );
  }
}
