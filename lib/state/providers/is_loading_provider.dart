import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/providers/auth_state_providers.dart';
import 'package:instant_gram/state/image_upload/providers/image_uploader_provider.dart';
import 'package:instant_gram/state/image_upload/typedef/is_loading.dart';

final isLoadingProvider = Provider<IsLoading>((ref) {
  final authState = ref.watch(authStateProvider);
  final isUploadingImage = ref.watch(imageUploaderProvider);

  return authState.isLoading || isUploadingImage;
});
