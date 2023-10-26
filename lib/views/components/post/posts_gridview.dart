import 'package:flutter/material.dart';
import 'package:instant_gram/main.dart';
import 'package:instant_gram/state/posts/models/post.dart';
import 'package:instant_gram/views/components/post/post_thumbnail_view.dart';

class PostGridView extends StatelessWidget {
  const PostGridView({
    required this.posts,
    super.key,
  });

  final Iterable<Post> posts;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts.elementAt(index);
        post.log;
        return PostThumbnailView(
          post: post,
          onTap: () {
            //TODO: Navigate to the post detail view
          },
        );
      },
    );
  }
}
