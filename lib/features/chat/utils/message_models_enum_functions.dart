import '../models/media_model.dart';
import '../models/message_model.dart';

ChatMessageType whatMessageType(String documentType) {
  const map = {
    'text': ChatMessageType.text,
    'audio': ChatMessageType.audio,
    'gallery': ChatMessageType.gallery,
    'media': ChatMessageType.media
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
    'not_viewed': MessageStatus.sent,
    'viewed': MessageStatus.viewed,
  };

  MessageStatus status = map[documentType] ?? MessageStatus.notSent;

  return status;
}

String messageTypeToString(ChatMessageType chatMessageType) {
  const map = {
    ChatMessageType.text: 'text',
    ChatMessageType.audio: 'audio',
    ChatMessageType.gallery: 'gallery',
    ChatMessageType.media: 'media',
  };

  String type = map[chatMessageType] ?? 'text';

  return type;
}

String messageStatusToString(MessageStatus messageStatus) {
  const map = {
    MessageStatus.notSent: 'not-send',
    MessageStatus.sent: 'not_viewed',
    MessageStatus.viewed: 'viewed',
  };

  String status = map[messageStatus] ?? 'not-send';

  return status;
}

String mediaTypeToString(MediaType mediaType) {
  const map = {
    MediaType.image: 'image',
    MediaType.video: 'video',
  };

  String type = map[mediaType] ?? 'image';

  return type;
}
