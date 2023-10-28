import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/posts/providers/post_by_search_term_provider.dart';
import 'package:instant_gram/state/posts/typedefs/search_term.dart';
import 'package:instant_gram/views/components/animations/data_not_found_animation_view.dart';

import 'package:instant_gram/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:instant_gram/views/components/animations/error_animation_view.dart';
import 'package:instant_gram/views/components/animations/loading_animation_view.dart';
import 'package:instant_gram/views/components/post/post_sliver_grid_view.dart';
import 'package:instant_gram/views/components/post/posts_grid_view.dart';
import 'package:instant_gram/views/constants/strings.dart';

class SearchGridView extends ConsumerWidget {
  const SearchGridView({
    super.key,
    required this.searchTeam,
  });

  final SearchTeam searchTeam;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchTeam.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyContentWithTextAnimationView(
          text: Strings.enterYourSearchTerm,
        ),
      );
    }
    final posts = ref.watch(postBySearchTermProvider(searchTeam));
    return posts.when(
      data: (post) {
        if (post.isEmpty) {
          return const SliverToBoxAdapter(
            child: DataNotFoundAnimationView(),
          );
        } else {
          return PostSliverGridView(posts: post);
        }
      },
      error: (error, stackTrace) {
        return const SliverToBoxAdapter(
          child: ErrorAnimationView(),
        );
      },
      loading: () {
        return const SliverToBoxAdapter(
          child: LoadingAnimationView(),
        );
      },
    );
  }
}
