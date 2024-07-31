import 'package:flutter_linkid_gami/game_data.dart';
import 'package:flutter_linkid_gami/gami_event_handler.dart';

import 'flutter_linkid_gami_platform_interface.dart';

class FlutterLinkidGami {
  static final FlutterLinkidGami shared = FlutterLinkidGami._internal();

  factory FlutterLinkidGami() {
    return shared;
  }

  FlutterLinkidGami._internal();

  Future<String?> getPlatformVersion() {
    return FlutterLinkidGamiPlatform.instance.getPlatformVersion();
  }

  void initSDK() {
    FlutterLinkidGamiPlatform.instance.initSDK();
  }

  void showGame({required GameData gameData}) {
    // GameData gameData = GameData(gameName: gameName, token: token, environment: environment);
    FlutterLinkidGamiPlatform.instance.showGame(gameData);
  }

  void setEventHandler(GamiEventHandler gamiEventHandler) {
    FlutterLinkidGamiPlatform.instance.setGamiEventHandler(gamiEventHandler);
  }
}
