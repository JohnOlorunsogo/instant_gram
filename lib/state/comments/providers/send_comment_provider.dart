import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/comments/notifiers/send_comment_notifier.dart';
import 'package:instant_gram/state/image_upload/typedef/is_loading.dart';

final sendCommentProvider =
    StateNotifierProvider<SendCommentNotifier, IsLoading>(
  (ref) => SendCommentNotifier(),
);
