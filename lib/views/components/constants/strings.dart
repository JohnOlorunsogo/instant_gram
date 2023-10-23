import 'package:flutter/foundation.dart';

@immutable
class Strings {
  static const allowLikesTitle = 'Allow likes';
  static const allowLikesDescription =
      'By allowing likes, users can like your posts';
  static const allowLikesStorageKey = 'allow_likes';
  static const allowCommentsTitle = 'Allow Comments';
  static const allowCommentsDescription =
      'By allowing comments, users can comment on your posts';
  static const allowCommentsStorageKey = 'allow_comments';

  static const loading = 'Loading...';
  static const person = 'person';
  static const people = 'people';
  static const likedThis = 'liked this';

  static const delete = 'Delete';
  static const areYouSureYouWantToDeleteThisPost =
      'Are you sure you want to delete this?';

  static const logOut = 'Log Out';
  static const areYouSureYouWantToLogOutOfTheApp =
      'Are you sure you want to logOut of the app?';

  static const cancel = 'Cancel';

  const Strings._();
}
