import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/main.dart';
import 'package:instant_gram/state/auth/backend/authenticator.dart';
import 'package:instant_gram/state/auth/models/auth_result.dart';
import 'package:instant_gram/state/auth/models/auth_state.dart';
import 'package:instant_gram/state/posts/typedefs/user_id.dart';
import 'package:instant_gram/state/user_info/backend/user_info_storage.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _authenticator = Authenticator();
  final UserInfoStorage _userInfoStorage = const UserInfoStorage();

  AuthStateNotifier()
      : super(
          const AuthState.unknown(),
        ) {
    if (_authenticator.isAlreadyLoggedIn) {
      state = AuthState(
        result: AuthResult.success,
        userId: _authenticator.userId,
        isLoading: false,
      );
    }
  }

  Future<void> logOut() async {
    state = state.copyWith(isLoading: true);
    await _authenticator.logOut();
    print('Logged Out');
    state = const AuthState.unknown();
  }

  Future<void> loginWithGoogle() async {
    state = state.copyWith(isLoading: true);
    final result = await _authenticator.loginWithGoogle();

    final userId = _authenticator.userId;

    if (result == AuthResult.success && userId != null) {
      //store userId in firestore
      await saveUserId(userId: userId);
    }

    state = AuthState(
      result: result,
      userId: userId,
      isLoading: false,
    );
  }

  Future<void> saveUserId({required UserId userId}) =>
      _userInfoStorage.saveUserInfo(
        userId: userId,
        displayName: _authenticator.displayName,
        email: _authenticator.email,
      );

  Future<void> loginWithFacebook() async {
    state = state.copyWith(isLoading: true);
    final result = await _authenticator.loginWithFacebook();

    final userId = _authenticator.userId;

    if (result == AuthResult.success && userId != null) {
      //store userId in firestore
      await saveUserId(userId: userId);
    }

    state = AuthState(
      result: result,
      userId: userId,
      isLoading: false,
    );
  }
}
