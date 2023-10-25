import 'package:flutter/foundation.dart' show immutable;

@immutable
class Constants {
  static const allowLikesTitle = 'Allow likes';
  static const allowLikesDescription =
      'By allowing likes, users can like your posts';
  static const allowLikesStorageKey = 'allow_likes';
  static const allowCommentsTitle = 'Allow Comments';
  static const allowCommentsDescription =
      'By allowing comments, users can comment on your posts';
  static const allowCommentsStorageKey = 'allow_comments';

  const Constants._();
}
