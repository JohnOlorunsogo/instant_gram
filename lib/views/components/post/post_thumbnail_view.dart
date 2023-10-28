import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/posts/models/post.dart';
import 'package:instant_gram/views/components/animations/error_animation_view.dart';

class PostThumbnailView extends ConsumerWidget {
  const PostThumbnailView({
    required this.post,
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.network(
          post.thumbnailUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress != null) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              return child;
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return const ErrorAnimationView();
          },
        ),
      ),
    );
  }
}
