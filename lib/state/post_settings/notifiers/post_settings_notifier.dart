import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/post_settings/models/post_settings.dart';

class PostSettingNotifier extends StateNotifier<Map<PostSettings, bool>> {
  PostSettingNotifier()
      : super(
          UnmodifiableMapView(
            {
              // PostSettings.allowComments: true,
              // PostSettings.allowLikes: true,
              for (final setting in PostSettings.values) setting: true,
            },
          ),
        );

  void setSetting(PostSettings settings, bool value) {
    final existingValue = state[settings];
    if (existingValue == null || existingValue == value) {
      return;
    }
    state = Map.unmodifiable(
      Map.from(state)..[settings] = value,
    );
  }
}
