import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/image_upload/typedef/is_loading.dart';
import 'package:instant_gram/state/posts/notifiers/delete_post_state_notifier.dart';

final deletePostProvider =
    StateNotifierProvider<DeletePostStateNotifier, IsLoading>(
  (ref) {
    return DeletePostStateNotifier();
  },
);
