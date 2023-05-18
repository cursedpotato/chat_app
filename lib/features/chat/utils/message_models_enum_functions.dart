import '../models/media_model.dart';
import '../models/message_model.dart';
// -------------------
// MessageType utils
// -------------------

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

// -------------------
// MessageStatus utils
// -------------------
MessageStatus messageStatusUtil(String documentType) {
  const map = {
    'not-send': MessageStatus.notSent,
    'not_viewed': MessageStatus.sent,
    'viewed': MessageStatus.viewed,
  };

  MessageStatus status = map[documentType] ?? MessageStatus.notSent;

  return status;
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

// -------------------
// MediaType utils
// -------------------

MediaType whatMediaType(String documentType) {
  const map = {
    'image': MediaType.image,
    'video': MediaType.video,
    'audio': MediaType.audio,
  };

  MediaType type = map[documentType] ?? MediaType.image;

  return type;
}

String mediaTypeToString(MediaType mediaType) {
  const map = {
    MediaType.image: 'image',
    MediaType.video: 'video',
    MediaType.audio: 'audio',
  };

  String type = map[mediaType] ?? 'image';

  return type;
}
