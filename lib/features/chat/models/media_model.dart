enum MediaType { image, video }

abstract class Media {
  MediaType mediaType;
  String mediaUrl;

  Media({
    required this.mediaType,
    required this.mediaUrl,
  });
}

class ImageMedia extends Media {
  ImageMedia({
    required MediaType mediaType,
    required String mediaUrl,
  }) : super(
          mediaType: mediaType,
          mediaUrl: mediaUrl,
        );
}

class VideoMedia extends Media {
  late final String thumbnailUrl;

  VideoMedia({
    required MediaType mediaType,
    required String mediaUrl,
    required this.thumbnailUrl,
  }) : super(
          mediaType: mediaType,
          mediaUrl: mediaUrl,
        );
}
