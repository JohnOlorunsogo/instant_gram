import 'package:flutter/material.dart';
import 'package:instant_gram/state/posts/models/post.dart';
import 'package:instant_gram/views/components/post/post_thumbnail_view.dart';
import 'package:instant_gram/views/components/post_detail/post_details_view.dart';

class PostSliverGridView extends StatelessWidget {
  const PostSliverGridView({
    super.key,
    required this.posts,
  });
  final Iterable<Post> posts;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      delegate: SliverChildBuilderDelegate(childCount: posts.length,
          (context, index) {
        final post = posts.elementAt(index);

        return PostThumbnailView(
          post: post,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return PostDetailsView(post: post);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
