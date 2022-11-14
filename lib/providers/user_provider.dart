
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter/foundation.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';



part 'user_provider.freezed.dart';


@freezed
abstract class UserState with _$UserState {
  const factory UserState({
    required UserModel userModel,
  }) = _UserState;

  // ignore: unused_element
  const UserState._();

}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) => UserNotifier());


class UserNotifier extends StateNotifier<UserState> {
  UserNotifier(): super(UserState(userModel: UserModel()));
  
  void userFromDocument(DocumentSnapshot documentSnapshot) {
       state = state.copyWith(userModel: UserModel.fromDocument(documentSnapshot));
  }
  
}

