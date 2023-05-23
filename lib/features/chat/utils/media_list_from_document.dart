import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/media_model.dart';
import 'message_models_enum_functions.dart';

List<Media> mediaListFromDocument(DocumentSnapshot<Object?> document) {
  final mediaList = <Media>[];
  final mediaListFromDocument = document['mediaList'] as List<dynamic>;
  for (var element in mediaListFromDocument) {
    final mediaType = whatMediaType(element['mediaType']);
    final mediaUrl = element['mediaUrl'] as String;
    if (mediaType == MediaType.image || mediaType == MediaType.audio) {
      mediaList.add(ImageMedia(
        mediaType: mediaType,
        mediaUrl: mediaUrl,
      ));
    } else {
      final thumbnailUrl = element['thumbnailUrl'] as String;
      mediaList.add(VideoMedia(
        mediaType: mediaType,
        mediaUrl: mediaUrl,
        thumbnailUrl: thumbnailUrl,
      ));
    }
  }
  return mediaList;
}
