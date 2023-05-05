import '../models/message_model.dart';

ChatMessageType whatMessageType(String documentType) {
  const map = {
    'text': ChatMessageType.text,
    'audio': ChatMessageType.audio,
    'gallery': ChatMessageType.gallery,
    'video': ChatMessageType.video
  };
  ChatMessageType type = map[documentType] ?? ChatMessageType.text;

  return type;
}

MediaType whatMediaType(String documentType) {
  const map = {
    'image': MediaType.image,
    'video': MediaType.video,
  };

  MediaType type = map[documentType] ?? MediaType.image;

  return type;
}

MessageStatus messageStatus(String documentType) {
  const map = {
    'not-send': MessageStatus.notSent,
    'not_viewed': MessageStatus.notViewed,
    'viewed': MessageStatus.viewed,
  };

  MessageStatus status = map[documentType] ?? MessageStatus.notSent;

  return status;
}
