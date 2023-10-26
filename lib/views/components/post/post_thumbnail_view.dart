import 'package:flutter/material.dart';
import 'package:instant_gram/state/posts/models/post.dart';

class PostThumbnailView extends StatelessWidget {
  const PostThumbnailView({
    required this.post,
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.network(
        post.thumbnailUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null
                ? child
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
    );
  }
}
