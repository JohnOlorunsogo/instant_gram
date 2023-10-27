import 'package:flutter/material.dart';
import 'package:instant_gram/state/image_upload/models/file_type.dart';
import 'package:instant_gram/state/posts/models/post.dart';
import 'package:instant_gram/views/components/post/post_image_view.dart';
import 'package:instant_gram/views/components/post/post_video_view.dart';

class PostImageOrVideoView extends StatelessWidget {
  const PostImageOrVideoView({
    required this.post,
    super.key,
  });
  final Post post;

  @override
  Widget build(BuildContext context) {
    // create the function and call it this same time
    return () {
      if (post.fileType == FileType.image) {
        return PostImageView(post: post);
      } else {
        return PostVideoView(post: post);
      }
    }();
  }
}
