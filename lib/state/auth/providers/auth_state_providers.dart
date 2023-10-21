import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/models/auth_state.dart';
import 'package:instant_gram/state/auth/notifiers/auth_sate_notifiers.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (_) => AuthStateNotifier(),
);
