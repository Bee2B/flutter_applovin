import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_applovin/flutter_applovin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    if (Platform.isIOS) {
      FlutterApplovin.init("2a4cf642c3f05167");
    } else if (Platform.isAndroid) {
      FlutterApplovin.init("9a5c7a46428fdd68");
    }
    super.initState();
  }

  void listener(AppLovionStatus status, AppLovinAdInfo info) {
    print(status);
    if (status == AppLovionStatus.didRewardUser) {
      print('👍get reward');
    }
  }

  bool isRewardedVideoAvailable = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: OutlinedButton(
            onPressed: () async {
              isRewardedVideoAvailable = await FlutterApplovin.isLoaded();
              if (isRewardedVideoAvailable) {
                FlutterApplovin.showRewordVideo(listener);
              }
            },
            child: Text('Show Reward Video'),
          ),
        ),
      ),
    );
  }
}
