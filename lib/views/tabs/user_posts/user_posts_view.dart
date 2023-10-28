import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/posts/providers/user_post_provider.dart';
import 'package:instant_gram/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:instant_gram/views/components/animations/error_animation_view.dart';
import 'package:instant_gram/views/components/animations/loading_animation_view.dart';
import 'package:instant_gram/views/components/post/posts_grid_view.dart';
import 'package:instant_gram/views/constants/strings.dart';

class UserPostView extends ConsumerWidget {
  const UserPostView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(userPostProvider);

    return RefreshIndicator(
      onRefresh: () {
        return ref.refresh(userPostProvider.future);
      },
      child: posts.when(
        data: (posts) {
          // posts.elementAt(0).log();
          if (posts.isEmpty) {
            return const EmptyContentWithTextAnimationView(
              text: Strings.youHaveNoPosts,
            );
          } else {
            return PostGridView(
              posts: posts,
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
    );
  }
}
