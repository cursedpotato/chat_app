import 'package:chat_app/core/utils/custom_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/routes/strings.dart';
import '../utils/media_list_from_document.dart';
import '../utils/message_models_enum_functions.dart';
import 'media_model.dart';

enum ChatMessageType { text, audio, gallery, media }

enum MessageStatus { notSent, sent, viewed, error }

class ChatMessageModel {
  late final String id;
  late final String message;
  late final ChatMessageType messageType;
  late final MessageStatus messageStatus;
  late final bool isSender;
  late final String pfpUrl;
  late final String sendBy;
  late final Timestamp timestamp;
  late final List<Media> mediaList;

  ChatMessageModel({
    required this.id,
    required this.message,
    required this.messageType,
    required this.messageStatus,
    required this.isSender,
    required this.pfpUrl,
    required this.sendBy,
    required this.timestamp,
    required this.mediaList,
  });

  ChatMessageModel.fromDocument(DocumentSnapshot document) {
    id = document.id;
    message = document.getString('message');
    messageType = whatMessageType(document.getString('messageType'));
    messageStatus = MessageStatus.viewed;
    isSender = chatterUsername == document['sendBy'];
    pfpUrl = document.getString('imgUrl');
    sendBy = document.getString('sendBy');
    timestamp = document.getTimeStamp('ts');
    mediaList = mediaListFromDocument(document);
  }

  // create to json method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'messageType': messageTypeToString(messageType),
      'messageStatus': messageStatusToString(messageStatus),
      'isSender': isSender,
      'pfpUrl': pfpUrl,
      'sendBy': sendBy,
      'timestamp': timestamp,
      'mediaList': mediaList.map((e) => e.toJson()).toList(),
    };
  }

  // create copywith method
  ChatMessageModel copyWith({
    String? id,
    String? message,
    ChatMessageType? messageType,
    MessageStatus? messageStatus,
    bool? isSender,
    String? pfpUrl,
    String? sendBy,
    Timestamp? timestamp,
    List<Media>? mediaList,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      message: message ?? this.message,
      messageType: messageType ?? this.messageType,
      messageStatus: messageStatus ?? this.messageStatus,
      isSender: isSender ?? this.isSender,
      pfpUrl: pfpUrl ?? this.pfpUrl,
      sendBy: sendBy ?? this.sendBy,
      timestamp: timestamp ?? this.timestamp,
      mediaList: mediaList ?? this.mediaList,
    );
  }
}
