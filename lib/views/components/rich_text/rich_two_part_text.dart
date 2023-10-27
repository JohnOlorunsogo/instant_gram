import 'package:flutter/material.dart';

class RichTwoPartText extends StatelessWidget {
  const RichTwoPartText({
    required this.leftPart,
    required this.rightPart,
    super.key,
  });

  final String leftPart;
  final String rightPart;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        children: [
          TextSpan(
            text: leftPart,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          TextSpan(
            text: '  $rightPart',
          ),
        ],
      ),
    );
  }
}
