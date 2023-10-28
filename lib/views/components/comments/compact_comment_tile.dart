import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/comments/models/comment.dart';
import 'package:instant_gram/state/user_info/providers/user_info_model_provider.dart';
import 'package:instant_gram/views/components/animations/small_error_animation_view.dart';
import 'package:instant_gram/views/components/rich_text/rich_two_part_text.dart';

class CompactCommentTile extends ConsumerWidget {
  const CompactCommentTile({
    super.key,
    required this.comment,
  });
  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(
      userInfoModelProvider(comment.userId),
    );
    return userInfo.when(
      data: (userInfo) {
        return RichTwoPartText(
          leftPart: userInfo.displayName,
          rightPart: comment.comment,
        );
      },
      error: (error, stackTrace) => const SmallErrorAnimationView(),
      loading: () => const CircularProgressIndicator.adaptive(),
    );
  }
}
