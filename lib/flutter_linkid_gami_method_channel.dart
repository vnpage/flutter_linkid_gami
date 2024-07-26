import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_linkid_gami_platform_interface.dart';

/// An implementation of [FlutterLinkidGamiPlatform] that uses method channels.
class MethodChannelFlutterLinkidGami extends FlutterLinkidGamiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_linkid_gami');

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
  Future<void> showGame() async {
    await methodChannel.invokeMethod<String>('showGame');
  }
}
