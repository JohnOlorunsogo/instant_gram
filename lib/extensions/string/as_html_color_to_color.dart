//convert html color to color
import 'dart:ui';

import 'package:instant_gram/extensions/string/remove_all.dart';

extension AsHtmlColorToColor on String {
  Color htmlColorToColor() => Color(
        int.parse(
          removeAll(['#', '0x']).padLeft(8, 'ff'),
          radix: 16,
        ),
      );
}
