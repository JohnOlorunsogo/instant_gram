import 'package:flutter/foundation.dart';
import 'package:instant_gram/state/constants/firebase_field_name.dart';
import 'dart:collection' show MapView;

import 'package:instant_gram/state/posts/typedefs/user_id.dart';

@immutable
class UserInfoPayload extends MapView<String, String> {
  UserInfoPayload({
    required String? displayName,
    required String? email,
    required UserId userId,
  }) : super(
          {
            FirebaseFieldName.displayName: displayName ?? '',
            FirebaseFieldName.email: email ?? '',
            FirebaseFieldName.userId: userId,
          },
        );
}
