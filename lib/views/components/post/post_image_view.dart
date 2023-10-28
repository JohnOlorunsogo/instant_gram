import 'package:flutter/material.dart';
import 'package:instant_gram/state/posts/models/post.dart';
import 'package:instant_gram/views/components/animations/error_animation_view.dart';

class PostImageView extends StatelessWidget {
  const PostImageView({
    required this.post,
    super.key,
  });
  final Post post;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: post.aspectRatio,
      child: Image.network(
        post.fileUrl,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const ErrorAnimationView();
        },
      ),
    );
  }
}
