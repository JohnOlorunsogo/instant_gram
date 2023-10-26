import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/providers/user_id_provider.dart';
import 'package:instant_gram/state/image_upload/models/file_type.dart';
import 'package:instant_gram/state/image_upload/models/thumbnail_request.dart';
import 'package:instant_gram/state/image_upload/providers/image_uploader_provider.dart';
import 'package:instant_gram/state/post_settings/models/post_settings.dart';
import 'package:instant_gram/state/post_settings/providers/post_settings_providers.dart';
import 'package:instant_gram/views/components/file_thumbnail_view.dart';
import 'package:instant_gram/views/constants/strings.dart';

class CreateNewPostView extends StatefulHookConsumerWidget {
  final File fileToPost;
  final FileType fileType;

  const CreateNewPostView({
    required this.fileToPost,
    required this.fileType,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewPostViewState();
}

class _CreateNewPostViewState extends ConsumerState<CreateNewPostView> {
  @override
  Widget build(BuildContext context) {
    final ThumbnailRequest thumbnailRequest = ThumbnailRequest(
      file: widget.fileToPost,
      fileType: widget.fileType,
    );

    final postSettings = ref.watch(postSettingsProvider);

    final postController = useTextEditingController();

    final isPostButtonEnabled = useState<bool>(false);

    useEffect(
      () {
        void listener() {
          isPostButtonEnabled.value = postController.text.isNotEmpty;
        }

        postController.addListener(listener);
        return () {
          postController.removeListener(listener);
        };
      },
      [postController],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.createNewPost),
        actions: [
          IconButton(
            onPressed: isPostButtonEnabled.value
                ? () async {
                    final userId = ref.read(userIdProvider);

                    if (userId == null) {
                      return;
                    }

                    final message = postController.text;

                    final isUploaded = await ref
                        .read(imageUploaderProvider.notifier)
                        .upload(
                            file: widget.fileToPost,
                            fileType: widget.fileType,
                            message: message,
                            postSettings: postSettings,
                            userId: userId);

                    if (isUploaded && mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                : null,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // thumbnail
            FileThumbnailView(thumbnailRequest: thumbnailRequest),
            const SizedBox(height: 10),

            // message
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: postController,
                decoration: const InputDecoration(
                  labelText: Strings.pleaseWriteYourMessageHere,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                autofocus: true,
                maxLines: null,
              ),
            ),

            // post settings
            ...PostSettings.values.map(
              (postSetting) => ListTile(
                title: Text(postSetting.title),
                subtitle: Text(postSetting.description),
                trailing: Switch(
                  onChanged: (isOn) {
                    ref
                        .read(postSettingsProvider.notifier)
                        .setSetting(postSetting, isOn);
                  },
                  value: postSettings[postSetting] ?? false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
