import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/providers/user_id_provider.dart';
import 'package:instant_gram/state/likes/models/like_dislike_request.dart';
import 'package:instant_gram/state/likes/providers/has_liked_post_provider.dart';
import 'package:instant_gram/state/likes/providers/like_dislike_post_provider.dart';
import 'package:instant_gram/state/posts/typedefs/post_id.dart';
import 'package:instant_gram/views/components/animations/small_error_animation_view.dart';

class LikeButton extends ConsumerWidget {
  const LikeButton({
    required this.postId,
    super.key,
  });
  final PostId postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.read(userIdProvider);
    final hasLiked = ref.watch(
      hasLikedPostProvider(postId),
    );
    return hasLiked.when(
      data: (hasLiked) {
        return IconButton(
          onPressed: () {
            if (userId == null) {
              return;
            }
            final request = LikeDislikeRequest(
              likedBy: userId,
              postId: postId,
            );

            ref.read(
              likeDislikePostProvider(request),
            );
          },
          icon: hasLiked
              ? const Icon(
                  Icons.favorite,
                )
              : const Icon(
                  Icons.favorite_border,
                ),
        );
      },
      error: (error, stackTrace) => const SmallErrorAnimationView(),
      loading: () => const CircularProgressIndicator.adaptive(),
    );
  }
}
