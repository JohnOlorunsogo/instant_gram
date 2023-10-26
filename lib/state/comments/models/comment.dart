import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instant_gram/state/comments/typedef/comment_id.dart';
import 'package:instant_gram/state/constants/firebase_field_name.dart';
import 'package:instant_gram/state/posts/typedefs/post_id.dart';
import 'package:instant_gram/state/posts/typedefs/user_id.dart';

class Comment {
  final CommentId commentId;
  final String comment;
  final DateTime createdAt;
  final UserId userId;
  final PostId postId;

  Comment(Map<String, dynamic> json, {required this.commentId})
      : comment = json[FirebaseFieldName.comments],
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate(),
        userId = json[FirebaseFieldName.userId],
        postId = json[FirebaseFieldName.postId];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          commentId == other.commentId &&
          comment == other.comment &&
          createdAt == other.createdAt &&
          userId == other.userId &&
          postId == other.postId;

  @override
  int get hashCode => Object.hashAll(
        [
          commentId,
          comment,
          createdAt,
          userId,
          postId,
        ],
      );
}
