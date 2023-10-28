import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instant_gram/state/comments/models/comment.dart';
import 'package:instant_gram/state/posts/models/post.dart';

@immutable
class PostWithComment {
  final Post post;
  final Iterable<Comment> comments;

  const PostWithComment({
    required this.post,
    required this.comments,
  });

  @override
  bool operator ==(covariant PostWithComment other) =>
      post == other.post &&
      const IterableEquality().equals(
        comments,
        other.comments,
      );

  @override
  int get hashCode => Object.hashAll(
        [runtimeType, post, comments],
      );
}
