import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:instant_gram/views/components/rich_text/base_text.dart';
import 'package:instant_gram/views/components/rich_text/link_text.dart';

class RichTextWidget extends StatelessWidget {
  final Iterable<BaseText> texts;
  final TextStyle? allStyle;

  const RichTextWidget({
    required this.texts,
    this.allStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: texts.map(
          (baseText) {
            if (baseText is LinkText) {
              return TextSpan(
                text: baseText.text,
                style: allStyle?.merge(baseText.style),
                recognizer: TapGestureRecognizer()..onTap = baseText.onTap,
              );
            } else {
              return TextSpan(
                text: baseText.text,
                style: allStyle?.merge(baseText.style),
              );
            }
          },
        ).toList(),
      ),
    );
  }
}
