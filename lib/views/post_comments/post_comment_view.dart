import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/providers/user_id_provider.dart';
import 'package:instant_gram/state/comments/models/post_comments_request.dart';
import 'package:instant_gram/state/comments/providers/post_comment_provider.dart';
import 'package:instant_gram/state/comments/providers/send_comment_provider.dart';
import 'package:instant_gram/state/posts/typedefs/post_id.dart';
import 'package:instant_gram/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:instant_gram/views/components/animations/error_animation_view.dart';
import 'package:instant_gram/views/components/animations/loading_animation_view.dart';
import 'package:instant_gram/views/components/comments/comment_tile.dart';
import 'package:instant_gram/views/constants/strings.dart';
import 'package:instant_gram/views/extensions/dismiss_keyboard.dart';

class PostCommentView extends HookConsumerWidget {
  final PostId postId;
  const PostCommentView({required this.postId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsController = useTextEditingController();

    final hasText = useState<bool>(false);

    final request = useState(RequestForPostAndComments(postId: postId));

    final comments = ref.watch(
      postCommentsProvider(
        request.value,
      ),
    );

    useEffect(
      () {
        commentsController.addListener(() {
          hasText.value = commentsController.text.isNotEmpty;
        });

        return () {};
      },
      [commentsController],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.comments),
        actions: [
          IconButton(
            onPressed: hasText.value
                ? () {
                    _submitCommentWithControllers(
                        controller: commentsController, ref: ref);
                  }
                : null,
            icon: const Icon(Icons.send),
          )
        ],
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 4,
              child: comments.when(
                data: (comments) {
                  if (comments.isEmpty) {
                    return const SingleChildScrollView(
                      child: EmptyContentWithTextAnimationView(
                        text: Strings.noCommentsYet,
                      ),
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: () {
                        return Future.delayed(const Duration(seconds: 2))
                            .then((value) {
                          return ref
                              .refresh(postCommentsProvider(request.value));
                        });
                      },
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final comment = comments.elementAt(index);
                          return CommentTile(comment: comment);
                        },
                        itemCount: comments.length,
                        padding: const EdgeInsets.all(8),
                      ),
                    );
                  }
                },
                error: (error, stackTrace) {
                  return const ErrorAnimationView();
                },
                loading: () {
                  return const LoadingAnimationView();
                },
              ),
            ),

            //Comments
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: TextField(
                    onSubmitted: (comment) {
                      if (comment.isNotEmpty) {
                        _submitCommentWithControllers(
                          controller: commentsController,
                          ref: ref,
                        );
                      }
                    },
                    textInputAction: TextInputAction.send,
                    controller: commentsController,
                    decoration: const InputDecoration(
                      labelText: Strings.writeYourCommentHere,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _submitCommentWithControllers({
    required TextEditingController controller,
    required WidgetRef ref,
  }) async {
    final userId = ref.read(userIdProvider);

    if (userId == null) {
      return;
    }

    final isSent = await ref.read(sendCommentProvider.notifier).sendComment(
          userId: userId,
          postId: postId,
          comment: controller.text,
        );

    if (isSent) {
      controller.clear();
      dismissKeyboard();
      return;
    }
  }
}
