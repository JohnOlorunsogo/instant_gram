import 'package:flutter/material.dart';
import 'package:instant_gram/views/components/animations/empty_content_animation_view.dart';

class EmptyContentWithTextAnimationView extends StatelessWidget {
  const EmptyContentWithTextAnimationView({
    required this.text,
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: EmptyContentAnimationView(),
          ),
        ],
      ),
    );
  }
}
