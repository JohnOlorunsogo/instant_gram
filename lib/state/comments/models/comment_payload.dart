import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instant_gram/state/constants/firebase_field_name.dart';
import 'package:instant_gram/state/posts/typedefs/post_id.dart';
import 'package:instant_gram/state/posts/typedefs/user_id.dart';

@immutable
class CommentPayload extends MapView<String, dynamic> {
  CommentPayload({
    required UserId userId,
    required String comment,
    required PostId postId,
  }) : super({
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.comments: comment,
          FirebaseFieldName.postId: postId,
          FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
        });
}
