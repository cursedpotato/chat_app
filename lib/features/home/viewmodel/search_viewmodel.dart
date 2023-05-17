import 'dart:async';

import 'package:chat_app/core/models/chat_user_model.dart';
import 'package:chat_app/features/home/services/search_database_services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/search_model.dart';

final searchViewModel =
    StateNotifierProvider.autoDispose<SearchViewModel, SearchModel>(
  (ref) => SearchViewModel(),
);

class SearchViewModel extends StateNotifier<SearchModel> {
  SearchViewModel()
      : super(
          const SearchModel(
            isSearching: false,
            users: [],
          ),
        );

  Future getUsers(query) async {
    state = state.copyWith(isSearching: true, users: []);
    final users = await _searchUsers(query);
    state = state.copyWith(users: users, isSearching: false);
  }

  Future<List<ChatUserModel>> _searchUsers(String query) async {
    final results = await Future.wait([
      SearchDatabaseService.getUserByName(query),
      SearchDatabaseService.getUserByUserName(query),
    ]);

    final users = <ChatUserModel>[];
    for (var result in results) {
      for (var user in result.docs) {
        users.add(ChatUserModel.fromJson(user.data()));
      }
    }
    return users;
  }
}
