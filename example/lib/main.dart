import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_applovin/flutter_applovin.dart';

import 'banner.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // AppLovinの初期化
  if (Platform.isIOS) {
    await FlutterApplovin.init("1f8b4b36e2dcd9eb");
  } else if (Platform.isAndroid) {
    await FlutterApplovin.init("68800be1515b53c2");
  }
  print('initalized complete');

  // 完全に初期化が終了するまで待つ。
  // await Future<void>.delayed(const Duration(seconds: 5));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
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
    print('■■■■■■■■■■■■■■■■■■■■■');
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
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
            const SizedBox(
              width: 350,
              height: 50,
              child: AppLovinBanner(
                size: Size(350,50),
              )
            ),
          ],
        )
      ),
    );
  }
}
