
import 'flutter_linkid_gami_platform_interface.dart';

class FlutterLinkidGami {
  Future<String?> getPlatformVersion() {
    return FlutterLinkidGamiPlatform.instance.getPlatformVersion();
  }
}
