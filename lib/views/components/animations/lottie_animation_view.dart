import 'package:flutter/material.dart';
import 'package:instant_gram/views/components/animations/models/lottie_animation.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationView extends StatelessWidget {
  final LottieAnimation animation;
  final bool reverse;
  final bool repeat;

  const LottieAnimationView({
    required this.animation,
    this.repeat = true,
    this.reverse = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Lottie.asset(
        animation.fullPath,
        repeat: repeat,
        reverse: reverse,
      );
}

extension GetFullPat on LottieAnimation {
  String get fullPath => 'assets/animation/$name.json';
}
