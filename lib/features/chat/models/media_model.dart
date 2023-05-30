import '../utils/message_models_enum_functions.dart';

enum MediaType { image, video, audio }

abstract class Media {
  MediaType mediaType;
  String mediaUrl;

  Media({
    required this.mediaType,
    required this.mediaUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'mediaType': mediaTypeToString(mediaType),
      'mediaUrl': mediaUrl,
    };
  }
}

class ImageMedia extends Media {
  ImageMedia({
    required MediaType mediaType,
    required String mediaUrl,
  }) : super(
          mediaType: mediaType,
          mediaUrl: mediaUrl,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaType': mediaTypeToString(mediaType),
      'mediaUrl': mediaUrl,
    };
  }
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaType': mediaTypeToString(mediaType),
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}

class AudioMedia extends Media {
  String localPath;
  AudioMedia({
    required MediaType mediaType,
    required String mediaUrl,
    this.localPath = "",
  }) : super(
          mediaType: mediaType,
          mediaUrl: mediaUrl,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaType': mediaTypeToString(mediaType),
      'mediaUrl': mediaUrl,
      'localPath': localPath,
    };
  }
}
