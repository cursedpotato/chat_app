
import 'package:chat_app/core/utils/custom_getters.dart';
import 'package:flutter/material.dart';

@immutable
class ChatUserModel {
  const ChatUserModel({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.email,
    required this.pushToken,
  });
  final String image;
  final String about;
  final String name;
  final String createdAt;
  final bool isOnline;
  final String id;
  final String lastActive;
  final String email;
  final String pushToken;

  // Create from json method
  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      image: json.getString('image'),
      about: json.getString('about'),
      name: json.getString('name'),
      createdAt: json.getString('created_at'),
      isOnline: json.getBool('is_online'),
      id: json.getString('id'),
      lastActive: json.getString('last_active'),
      email: json.getString('email'),
      pushToken: json.getString('push_token'),
    );
  }

  // create copywith method
  ChatUserModel copyWith({
    String? image,
    String? about,
    String? name,
    String? createdAt,
    bool? isOnline,
    String? id,
    String? lastActive,
    String? email,
    String? pushToken,
  }) {
    return ChatUserModel(
      image: image ?? this.image,
      about: about ?? this.about,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      isOnline: isOnline ?? this.isOnline,
      id: id ?? this.id,
      lastActive: lastActive ?? this.lastActive,
      email: email ?? this.email,
      pushToken: pushToken ?? this.pushToken,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}
