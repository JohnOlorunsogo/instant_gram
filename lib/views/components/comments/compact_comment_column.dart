import 'package:flutter/material.dart';

import 'package:instant_gram/state/comments/models/comment.dart';
import 'package:instant_gram/views/components/comments/compact_comment_tile.dart';

class CompactCommentColumn extends StatelessWidget {
  const CompactCommentColumn({
    super.key,
    required this.comments,
  });
  final Iterable<Comment> comments;

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: comments
              .map(
                (comment) => CompactCommentTile(
                  comment: comment,
                ),
              )
              .toList(),
        ),
      );
    }
  }
}
