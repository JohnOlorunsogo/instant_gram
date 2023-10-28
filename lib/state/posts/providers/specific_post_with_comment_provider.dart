import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/constants/firebase_collection_name.dart';
import 'package:instant_gram/state/comments/extensions/comment_sorting_by_request.dart';
import 'package:instant_gram/state/comments/models/comment.dart';
import 'package:instant_gram/state/comments/models/post_comments_request.dart';
import 'package:instant_gram/state/comments/models/post_with_comment.dart';
import 'package:instant_gram/state/constants/firebase_field_name.dart';
import 'package:instant_gram/state/posts/models/post.dart';

final specificPostWithCommentProvider = StreamProvider.family
    .autoDispose<PostWithComment, RequestForPostAndComments>(
  (ref, request) {
    final controller = StreamController<PostWithComment>();

    Post? post;
    Iterable<Comment>? comments;

    void notify() {
      final localPost = post;
      if (localPost == null) {
        return;
      }

      final outputComment = (comments ?? []).applySortingFrom(request);

      final result = PostWithComment(
        comments: outputComment,
        post: localPost,
      );

      controller.sink.add(result);
    }

    //watch changes in post

    final sub = FirebaseFirestore.instance
        .collection(
          FirebaseCollectionName.posts,
        )
        .where(
          FieldPath.documentId,
          isEqualTo: request.postId,
        )
        .limit(1)
        .snapshots()
        .listen(
      (snapshot) {
        if (snapshot.docs.isEmpty) {
          post = null;
          comments = null;
          notify();
          return;
        }

        final doc = snapshot.docs.first;

        if (doc.metadata.hasPendingWrites) {
          return;
        }
        post = Post(postId: request.postId, json: doc.data());
        notify();
      },
    );

    //watch changes in comments
    final commentQuery = FirebaseFirestore.instance
        .collection(
          FirebaseCollectionName.comments,
        )
        .where(FirebaseFieldName.postId, isEqualTo: request.postId)
        .orderBy(
          FirebaseFieldName.createdAt,
          descending: true,
        );

    final limitedCommentQuery = request.limit != null
        ? commentQuery.limit(request.limit!)
        : commentQuery;

    final commentSub = limitedCommentQuery.snapshots().listen(
      (snapshot) {
        comments = snapshot.docs
            .where((doc) => !doc.metadata.hasPendingWrites)
            .map(
              (doc) => Comment(
                doc.data(),
                commentId: doc.id,
              ),
            )
            .toList();
        notify();
      },
    );

    ref.onDispose(() {
      sub.cancel();
      commentSub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
