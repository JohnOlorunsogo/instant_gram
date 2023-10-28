import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/providers/user_id_provider.dart';
import 'package:instant_gram/state/posts/models/post.dart';

final canCurrentUserDeletePostProvider =
    StreamProvider.family.autoDispose<bool, Post>(
  (ref, post) async* {
    final userId = ref.watch(userIdProvider);
    // post.userId.log();
    final bool canDelete = userId! == post.userId;
    yield canDelete;
  },
);
