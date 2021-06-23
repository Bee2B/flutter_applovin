library applovin;

import 'dart:async';

import 'package:flutter/services.dart';

enum AppLovionStatus {
  didLoad,
  didFailToLoadAd,
  didDisplay,
  didClick,
  didHide,
  didFailToDisplay,
  didPayRevenue,
  didStartRewardedVideo,
  didCompleteRewardedVideo,
  didRewardUser,
}

class AppLovinAdInfo {
  AppLovinAdInfo({
    this.format = '',
    this.adUnitIdentifier = '',
    this.networkName = '',
    this.creativeIdentifier = '',
    this.revenue = -1,
    this.placement = '',
  });

  final String format;
  final String adUnitIdentifier;
  final String networkName;
  final String creativeIdentifier;
  final double revenue;
  final String placement;
}

typedef AppLovinCallback = Function(AppLovionStatus status, AppLovinAdInfo info);

class FlutterApplovin {
  static const MethodChannel _channel = MethodChannel('flutter_applovin');

  static Future<bool> init(String unitId) async {
    return await _channel.invokeMethod<bool>('init', <String, dynamic>{'unitId': unitId}) ?? false;
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
      case 'didFailToDisplay':
        return AppLovionStatus.didFailToDisplay;
      case 'didPayRevenue':
        return AppLovionStatus.didPayRevenue;
      case 'didStartRewardedVideo':
        return AppLovionStatus.didStartRewardedVideo;
      case 'didCompleteRewardedVideo':
        return AppLovionStatus.didCompleteRewardedVideo;
      case 'didRewardUser':
        return AppLovionStatus.didRewardUser;
      default:
        return AppLovionStatus.didFailToLoadAd;
    }
  }

  static AppLovinAdInfo appLovinAdInfoFrom(dynamic value) {
    try {
      final Map<dynamic, dynamic> map = value as Map<dynamic, dynamic>;
      final String format = (map['format'] as String?) ?? '';
      final String adUnitIdentifier = (map['adUnitIdentifier'] as String?) ?? '';
      final String networkName = (map['networkName'] as String?) ?? '';
      final String creativeIdentifier = (map['creativeIdentifier'] as String?) ?? '';
      final double revenue = (map['revenue'] as double?) ?? -1;
      final String placement = (map['placement'] as String?) ?? '';
      return AppLovinAdInfo(
        format: format,
        adUnitIdentifier: adUnitIdentifier,
        networkName: networkName,
        creativeIdentifier: creativeIdentifier,
        revenue: revenue,
        placement: placement,
      );
    } catch (e) {
      return AppLovinAdInfo();
    }
  }
}
