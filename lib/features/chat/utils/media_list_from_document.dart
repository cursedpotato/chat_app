import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/media_model.dart';
import 'message_models_enum_functions.dart';

List<Media> mediaListFromDocument(DocumentSnapshot<Object?> document) {
  final mediaList = <Media>[];
  final mediaListFromDocument = document['mediaList'] as List<dynamic>;
  for (var element in mediaListFromDocument) {
    final mediaType = whatMediaType(element['mediaType']);
    final mediaUrl = element['mediaUrl'] as String;

    if (mediaType == MediaType.audio) {
      final localPath = element['localPath'] as String;
      mediaList.add(
        AudioMedia(
          mediaType: mediaType,
          mediaUrl: mediaUrl,
          localPath: localPath,
        ),
      );
    }
    if (mediaType == MediaType.image) {
      mediaList.add(
        ImageMedia(
          mediaType: mediaType,
          mediaUrl: mediaUrl,
        ),
      );
    }
    if (mediaType == MediaType.video) {
      final thumbnailUrl = element['thumbnailUrl'] as String;
      mediaList.add(
        VideoMedia(
          thumbnailUrl: thumbnailUrl,
          mediaType: mediaType,
          mediaUrl: mediaUrl,
        ),
      );
    }
  }
  return mediaList;
}
