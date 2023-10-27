import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/likes/providers/post_likes_count_provider.dart';
import 'package:instant_gram/state/posts/typedefs/post_id.dart';
import 'package:instant_gram/views/components/animations/small_error_animation_view.dart';
import 'package:instant_gram/views/components/constants/strings.dart';

class LikesCountView extends ConsumerWidget {
  const LikesCountView({required this.postId, super.key});
  final PostId postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesCount = ref.watch(postLikesCountProvider(postId));
    return likesCount.when(
      data: (count) {
        final personOrPeople = count == 1 ? Strings.person : Strings.people;

        return Text(
          '$count $personOrPeople liked this',
        );
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }
}
