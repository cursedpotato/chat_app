import 'package:chat_app/core/models/chat_user_model.dart';
import 'package:flutter/foundation.dart';

@immutable
class SearchModel {
  final bool isSearching;
  final List<ChatUserModel> users;

  const SearchModel({
    this.isSearching = false,
    this.users = const [],
  });

  SearchModel copyWith({
    required bool isSearching,
    required List<ChatUserModel> users,
  }) {
    return SearchModel(
      isSearching: isSearching,
      users: users,
    );
  }
}
