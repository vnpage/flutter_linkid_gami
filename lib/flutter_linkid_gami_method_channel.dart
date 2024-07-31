import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkid_gami/game_data.dart';

import 'flutter_linkid_gami_platform_interface.dart';
import 'gami_event_handler.dart';

/// An implementation of [FlutterLinkidGamiPlatform] that uses method channels.
class MethodChannelFlutterLinkidGami extends FlutterLinkidGamiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_linkid_gami');
  GamiEventHandler? _gamiEventHandler;

  MethodChannelFlutterLinkidGami() : super() {
    methodChannel.setMethodCallHandler((call) async {
      // you can get hear method and passed arguments with method
      print("method ${call.method}");
      if (call.method == "onEventTracking") {
        _gamiEventHandler?.onEventTracking(call.arguments);
      }
    });
  }

  @override
  void setGamiEventHandler(GamiEventHandler gamiEventHandler) {
    _gamiEventHandler = gamiEventHandler;
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> initSDK() async {
    await methodChannel.invokeMethod<String>('initSDK');
  }

  @override
  Future<void> showGame(GameData gameData) async {
    final result = await methodChannel.invokeMethod<String>('showGame', gameData.toMap());
    print('Result from native: $result');
  }
}
