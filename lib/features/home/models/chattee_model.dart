import 'package:chat_app/core/models/chat_user_model.dart';
import 'package:flutter/material.dart';

@immutable
class ChattesModel {
  final List<ChatUserModel> chattes;

  const ChattesModel({
    this.chattes = const [],
  });

  ChattesModel copyWith({
    required List<ChatUserModel> chattes,
  }) {
    return ChattesModel(
      chattes: chattes,
    );
  }
}
