import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/enums/date_sorting.dart';
import 'package:instant_gram/state/comments/models/post_comments_request.dart';
import 'package:instant_gram/state/posts/models/post.dart';
import 'package:instant_gram/state/posts/providers/can_current_user_delete_post_provider.dart';
import 'package:instant_gram/state/posts/providers/delete_post_provider.dart';
import 'package:instant_gram/state/posts/providers/specific_post_with_comment_provider.dart';
import 'package:instant_gram/views/components/animations/small_error_animation_view.dart';
import 'package:instant_gram/views/components/comments/campact_comment_column.dart';
import 'package:instant_gram/views/components/dialogs/alert_dialog_model.dart';
import 'package:instant_gram/views/components/dialogs/delete_dialog.dart';
import 'package:instant_gram/views/components/like_button.dart';
import 'package:instant_gram/views/components/post/likes_count_view.dart';
import 'package:instant_gram/views/components/post/post_date_view.dart';
import 'package:instant_gram/views/components/post/post_display_name_and_message_view.dart';
import 'package:instant_gram/views/components/post/post_image_or_video_view.dart';
import 'package:instant_gram/views/constants/strings.dart';
import 'package:instant_gram/views/post_comments/post_comment_view.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailsView extends ConsumerStatefulWidget {
  const PostDetailsView({super.key, required this.post});
  final Post post;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostDetailsViewState();
}

class _PostDetailsViewState extends ConsumerState<PostDetailsView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
      postId: widget.post.postId,
      sortByCreatedAt: true,
      dateSorting: DateSorting.oldestOnTop,
    );

    // get the post and comment
    final postWithComment = ref.watch(
      specificPostWithCommentProvider(request),
    );

    final canDeletePost = ref.watch(
      canCurrentUserDeletePostProvider(
        widget.post,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.postDetails),
        actions: [
          // share button
          postWithComment.when(
            data: (data) {
              return IconButton(
                onPressed: () {
                  final url = data.post.fileUrl;
                  Share.share(
                    url,
                    subject: Strings.checkOutThisPost,
                  );
                },
                icon: const Icon(Icons.share),
              );
            },
            error: (error, stackTrace) {
              return const SmallErrorAnimationView();
            },
            loading: () {
              return const CircularProgressIndicator.adaptive();
            },
          ),

          //delete button
          if (canDeletePost.value ?? false)
            IconButton(
              onPressed: () async {
                final shouldDeletePost = await const DeleteDialog(
                  titleOfObjectToDelete: Strings.post,
                ).present(context).then(
                      (shouldDelete) => shouldDelete ?? false,
                    );

                if (shouldDeletePost) {
                  await ref.read(deletePostProvider.notifier).deletePost(
                        post: widget.post,
                      );

                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              icon: const Icon(Icons.delete),
            )
        ],
      ),
      body: postWithComment.when(
        data: (postWithComments) {
          final postId = postWithComments.post.postId;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostImageOrVideoView(
                  post: postWithComments.post,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Like button if post allows liking
                    if (postWithComments.post.allowLikes)
                      LikeButton(postId: postId),

                    // Comment button if post allows commenting
                    if (postWithComments.post.allowComments)
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PostCommentView(
                                  postId: postId,
                                );
                              },
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.comment_outlined,
                        ),
                      )
                  ],
                ),

                // post details
                PostDisplayNameAndMessageView(
                  post: postWithComments.post,
                ),

                PostDateView(
                  date: postWithComments.post.createdAt,
                ),

                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(),
                ),

                CompactCommentColumn(
                  comments: postWithComments.comments,
                ),

                //display like count if post allows likes
                if (postWithComments.post.allowLikes)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        LikesCountView(postId: postId),
                      ],
                    ),
                  ),

                const SizedBox(
                  height: 100,
                )
              ],
            ),
          );
        },
        error: (error, stackTrace) => const SmallErrorAnimationView(),
        loading: () => const CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
