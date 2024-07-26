
import 'flutter_linkid_gami_platform_interface.dart';

class FlutterLinkidGami {
  static final FlutterLinkidGami shared =
  FlutterLinkidGami._internal();

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

  void showGame() {
    FlutterLinkidGamiPlatform.instance.showGame();
  }
}
