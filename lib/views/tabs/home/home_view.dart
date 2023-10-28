import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/posts/providers/all_post_provider.dart';
import 'package:instant_gram/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:instant_gram/views/components/animations/error_animation_view.dart';
import 'package:instant_gram/views/components/animations/loading_animation_view.dart';
import 'package:instant_gram/views/components/post/posts_grid_view.dart';
import 'package:instant_gram/views/constants/strings.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(allPostsProvider);

    return RefreshIndicator(
      child: posts.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const EmptyContentWithTextAnimationView(
                text: Strings.noPostsAvailable);
          }
          return PostGridView(posts: posts);
        },
        error: (error, stackTrace) => const ErrorAnimationView(),
        loading: () => const LoadingAnimationView(),
      ),
      onRefresh: () => ref.refresh(allPostsProvider.future),
    );
  }
}
