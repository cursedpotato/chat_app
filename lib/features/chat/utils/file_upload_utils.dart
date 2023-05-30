import 'dart:io';

import 'package:chat_app/features/chat/models/media_model.dart';
import 'package:chat_app/features/chat/services/message_storage_services.dart';

Future<Media> mediaTypeToModel(
  MediaType mediaType,
  File file,
  String id,
) async {
  final mediaUrl =
      await MessageStorageServices().uploadFileToStorage(file.path, id);
  if (mediaType == MediaType.video) {
    final thumbnailUrl =
        await MessageStorageServices().uploadThumbnail(file, id);
    return VideoMedia(
      mediaType: mediaType,
      mediaUrl: mediaUrl,
      thumbnailUrl: thumbnailUrl,
    );
  }

  if (mediaType == MediaType.audio) {
    return AudioMedia(mediaType: mediaType, mediaUrl: mediaUrl);
  }

  return ImageMedia(mediaType: mediaType, mediaUrl: mediaUrl);
}

MediaType fileMediaType(File file) {
  final videoFormats = ['.mp4', '.mov', '.avi'];
  final isVideo = containsAny(file.path, videoFormats);

  final audioFormats = ['.mp3', '.aac', '.m4a'];
  final isAudio = containsAny(file.path, audioFormats);
  if (isVideo) return MediaType.video;
  if (isAudio) return MediaType.audio;

  return MediaType.image;
}

bool containsAny(String text, List<String> substrings) {
  // returns true if any substring of the [substrings] list is contained in the [text]
  for (var substring in substrings) {
    if (text.contains(substring)) return true;
  }
  return false;
}
