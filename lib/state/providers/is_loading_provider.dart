import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/providers/auth_state_providers.dart';
import 'package:instant_gram/state/comments/providers/delete_comment_provider.dart';
import 'package:instant_gram/state/comments/providers/send_comment_provider.dart';
import 'package:instant_gram/state/image_upload/providers/image_uploader_provider.dart';
import 'package:instant_gram/state/image_upload/typedef/is_loading.dart';
import 'package:instant_gram/state/posts/providers/delete_post_provider.dart';

final isLoadingProvider = Provider<IsLoading>((ref) {
  final authState = ref.watch(authStateProvider);
  final isUploadingImage = ref.watch(imageUploaderProvider);
  final isSendingComment = ref.watch(sendCommentProvider);
  final deletingComment = ref.watch(deleteCommentProvider);
  final deletingPost = ref.watch(deletePostProvider);

  return authState.isLoading ||
      isUploadingImage ||
      isSendingComment ||
      deletingPost ||
      deletingComment;
});
