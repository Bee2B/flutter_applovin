import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppLovinBanner extends StatelessWidget {
  const AppLovinBanner({Key? key, required this.size}) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    const String viewType = 'AppLovinBanner';
    Widget child = Container();
    if (Platform.isIOS) {
      child = UiKitView(
        viewType: viewType,
        creationParams: {
          'width': size.width,
          'height': size.height,
        },
        creationParamsCodec: const StandardMessageCodec(),
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{Factory<OneSequenceGestureRecognizer>(() => TapGestureRecognizer())},
      );
    } else if (Platform.isAndroid) {
      child = AndroidView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: {
          'width': size.width,
          'height': size.height,
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return child;
  }
}
