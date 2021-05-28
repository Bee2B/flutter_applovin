library applovin;

import 'dart:async';

import 'package:flutter/services.dart';

enum AppLovionStatus {
  didLoad,
  didFailToLoadAd,
  didDisplay,
  didClick,
  didHide,
  didFail,
  didPayRevenue,
  didStartRewardedVideo,
  didCompleteRewardedVideo,
  didRewardUser,
}

class AppLovinAdInfo {}

typedef AppLovinCallback = Function(AppLovionStatus status, AppLovinAdInfo info);

class FlutterApplovin {
  static const MethodChannel _channel = MethodChannel('flutter_applovin');

  static Future<void> init(String unitId) {
    return _channel.invokeMethod<void>('init', <String, dynamic>{'unitId': unitId});
  }

  static Future<void> showRewordVideo(AppLovinCallback callback) async {
    _channel.setMethodCallHandler((MethodCall call) async => callback(appLovionStatusFrom(call.method), appLovinAdInfoFrom(call.arguments)));
    await _channel.invokeMethod<void>('showRewardVideo');
  }

  static Future<bool> isLoaded() async {
    return await _channel.invokeMethod<bool>('isLoaded') ?? false;
  }

  static AppLovionStatus appLovionStatusFrom(String value) {
    switch (value) {
      case 'didLoad':
        return AppLovionStatus.didLoad;
      case 'didFailToLoadAd':
        return AppLovionStatus.didFailToLoadAd;
      case 'didDisplay':
        return AppLovionStatus.didDisplay;
      case 'didClick':
        return AppLovionStatus.didClick;
      case 'didHide':
        return AppLovionStatus.didHide;
      case 'didFail':
        return AppLovionStatus.didFail;
      case 'didPayRevenue':
        return AppLovionStatus.didPayRevenue;
      case 'didStartRewardedVideo':
        return AppLovionStatus.didStartRewardedVideo;
      case 'didCompleteRewardedVideo':
        return AppLovionStatus.didCompleteRewardedVideo;
      case 'didRewardUser':
        return AppLovionStatus.didRewardUser;
      default:
        return AppLovionStatus.didFail;
    }
  }

  static AppLovinAdInfo appLovinAdInfoFrom(dynamic value) {
    return AppLovinAdInfo();
  }
}
