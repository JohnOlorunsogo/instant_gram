import 'dart:async';

import 'package:flutter/material.dart' as material
    show Image, ImageConfiguration, ImageStreamListener;

extension GetImageAspectRatio on material.Image {
  Future<double> getAspectRatio() async {
    final completer = Completer<double>();
    image.resolve(const material.ImageConfiguration()).addListener(
      material.ImageStreamListener(
        (info, _) {
          final width = info.image.width;
          final height = info.image.height;
          final aspectRatio = width / height;

          info.image.dispose();

          completer.complete(aspectRatio);
        },
      ),
    );
    return completer.future;
  }
}
