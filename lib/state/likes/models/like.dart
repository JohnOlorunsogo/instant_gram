import 'dart:collection';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instant_gram/state/constants/firebase_field_name.dart';
import 'package:instant_gram/state/posts/typedefs/post_id.dart';
import 'package:instant_gram/state/posts/typedefs/user_id.dart';

@immutable
class Like extends MapView<String, String> {
  Like({
    required PostId postId,
    required UserId likedBy,
    required DateTime dateTime,
  }) : super({
          FirebaseFieldName.postId: postId,
          FirebaseFieldName.userId: likedBy,
          FirebaseFieldName.date: dateTime.toIso8601String(),
        });
}
