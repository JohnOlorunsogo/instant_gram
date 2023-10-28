// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/providers/auth_state_providers.dart';
import 'package:instant_gram/state/image_upload/helpers/image_picker_helper.dart';
import 'package:instant_gram/state/image_upload/models/file_type.dart';
import 'package:instant_gram/state/post_settings/providers/post_settings_providers.dart';

import 'package:instant_gram/views/components/dialogs/alert_dialog_model.dart';
import 'package:instant_gram/views/components/dialogs/logout_dialog.dart';
import 'package:instant_gram/views/constants/strings.dart';
import 'package:instant_gram/views/create_new_post/create_new_post_view.dart';
import 'package:instant_gram/views/tabs/home/home_view.dart';
import 'package:instant_gram/views/tabs/search/search_view.dart';
import 'package:instant_gram/views/tabs/user_posts/user_posts_view.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            Strings.appName,
          ),
          actions: [
            IconButton(
              onPressed: () async {
                final videoFile =
                    await ImagePickerHelper.pickVideoFromGallery();
                if (videoFile == null) {
                  return;
                }

                ref.refresh(postSettingsProvider);

                // go to the screen to create new post

                if (!mounted) {
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CreateNewPostView(
                        fileToPost: videoFile,
                        fileType: FileType.video,
                      );
                    },
                  ),
                );
              },
              icon: const FaIcon(FontAwesomeIcons.film),
            ),
            IconButton(
              onPressed: () async {
                final imageFile =
                    await ImagePickerHelper.pickImageFromGallery();
                if (imageFile == null) {
                  return;
                }
                ref.refresh(postSettingsProvider);

                // go to the screen to create new post

                if (!mounted) {
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CreateNewPostView(
                        fileToPost: imageFile,
                        fileType: FileType.image,
                      );
                    },
                  ),
                );
              },
              icon: const Icon(Icons.add_photo_alternate_outlined),
            ),
            IconButton(
              onPressed: () async {
                final shouldLogout = await const LogoutDialog()
                    .present(context)
                    .then((value) => value ?? false);

                if (shouldLogout) {
                  await ref.read(authStateProvider.notifier).logOut();
                }
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.search),
              ),
              Tab(
                icon: Icon(Icons.person),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomeView(),
            SearchView(),
            UserPostView(),
          ],
        ),
      ),
    );
  }
}
