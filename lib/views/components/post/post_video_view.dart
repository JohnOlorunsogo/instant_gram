import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:instant_gram/state/posts/models/post.dart';
import 'package:instant_gram/views/components/animations/error_animation_view.dart';
import 'package:instant_gram/views/components/animations/loading_animation_view.dart';
import 'package:video_player/video_player.dart';

class PostVideoView extends HookWidget {
  const PostVideoView({
    required this.post,
    super.key,
  });
  final Post post;

  @override
  Widget build(BuildContext context) {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(post.fileUrl),
    );

    final isVideoPlayerReady = useState(false);

    useEffect(
      () {
        controller.initialize().then((value) {
          isVideoPlayerReady.value = true;
          controller.setLooping(true);
          controller.play();
        });

        return controller.dispose;
      },
      [controller],
    );

    switch (isVideoPlayerReady.value) {
      case true:
        return AspectRatio(
          aspectRatio: post.aspectRatio,
          child: VideoPlayer(controller),
        );
      case false:
        return const LoadingAnimationView();

      default:
        return const ErrorAnimationView();
    }
  }
}
