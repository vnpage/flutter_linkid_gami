import 'package:flutter_linkid_gami/game_data.dart';
import 'package:flutter_linkid_gami/gami_event_handler.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_linkid_gami_method_channel.dart';

abstract class FlutterLinkidGamiPlatform extends PlatformInterface {
  /// Constructs a FlutterLinkidGamiPlatform.
  FlutterLinkidGamiPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLinkidGamiPlatform _instance = MethodChannelFlutterLinkidGami();

  /// The default instance of [FlutterLinkidGamiPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLinkidGami].
  static FlutterLinkidGamiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLinkidGamiPlatform] when
  /// they register themselves.
  static set instance(FlutterLinkidGamiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> showGame(GameData gameData) {
    throw UnimplementedError('showGame() has not been implemented.');
  }

  void setGamiEventHandler(GamiEventHandler gamiEventHandler) {
    throw UnimplementedError('setGamiEventHandler() has not been implemented.');
  }
}
