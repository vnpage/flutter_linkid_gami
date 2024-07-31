import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_linkid_gami/flutter_linkid_gami.dart';
import 'package:flutter_linkid_gami/game_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterLinkidGamiPlugin = FlutterLinkidGami();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterLinkidGamiPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Text('Running on: $_platformVersion\n'),
            InkWell(
              onTap: () {
                GameData data = GameData(
                    gameName: 'gameTowerBloxx',
                    token:
                        'qFRB3Cq1W+efIiO1+M5LWcnPL/lLtmFGQw9ecp5CFOp6uzoHqKNkvuaYERQYBynbiTLhW5PStzTssdktP12z+lskEY1Iv+TC',
                    environment: 'uat');
                _flutterLinkidGamiPlugin.showGame(gameData: data);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.blue,
                child: const Text('Show Game', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
