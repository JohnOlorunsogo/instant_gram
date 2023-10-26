import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/constants/firebase_collection_name.dart';
import 'package:instant_gram/state/comments/models/comment_payload.dart';
import 'package:instant_gram/state/image_upload/typedef/is_loading.dart';
import 'package:instant_gram/state/posts/typedefs/post_id.dart';
import 'package:instant_gram/state/posts/typedefs/user_id.dart';

class SendCommentNotifier extends StateNotifier<IsLoading> {
  SendCommentNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> sendComment({
    required UserId userId,
    required PostId postId,
    required String comment,
  }) async {
    isLoading = true;

    final payload =
        CommentPayload(comment: comment, postId: postId, userId: userId);

    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.comments)
          .add(payload);
      return true;
    } catch (e) {
      isLoading = false;
      return false;
    } finally {
      isLoading = false;
    }
  }
}
