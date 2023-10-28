import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/constants/firebase_collection_name.dart';
import 'package:instant_gram/state/comments/extensions/comment_sorting_by_request.dart';
import 'package:instant_gram/state/comments/models/comment.dart';
import 'package:instant_gram/state/comments/models/post_comments_request.dart';
import 'package:instant_gram/state/constants/firebase_field_name.dart';

final postCommentsProvider = StreamProvider.family
    .autoDispose<Iterable<Comment>, RequestForPostAndComments>(
  (ref, request) {
    final controller = StreamController<Iterable<Comment>>();

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.comments)
        .where(
          FirebaseFieldName.postId,
          isEqualTo: request.postId,
        )
        .snapshots()
        .listen(
      (snapshot) {
        final documents = snapshot.docs;

        final limitedDocument =
            request.limit != null ? documents.take(request.limit!) : documents;

        final comments = limitedDocument
            .where((doc) => !doc.metadata.hasPendingWrites)
            .map((doc) {
          // doc.log();
          return Comment(
            doc.data(),
            commentId: doc.id,
          );
        });

        // print(comments.length);
        final result = comments.applySortingFrom(request);
        controller.sink.add(result);
      },
    );

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
