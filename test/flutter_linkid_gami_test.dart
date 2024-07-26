import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_linkid_gami/flutter_linkid_gami.dart';
import 'package:flutter_linkid_gami/flutter_linkid_gami_platform_interface.dart';
import 'package:flutter_linkid_gami/flutter_linkid_gami_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterLinkidGamiPlatform
    with MockPlatformInterfaceMixin
    implements FlutterLinkidGamiPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterLinkidGamiPlatform initialPlatform = FlutterLinkidGamiPlatform.instance;

  test('$MethodChannelFlutterLinkidGami is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterLinkidGami>());
  });

  test('getPlatformVersion', () async {
    FlutterLinkidGami flutterLinkidGamiPlugin = FlutterLinkidGami();
    MockFlutterLinkidGamiPlatform fakePlatform = MockFlutterLinkidGamiPlatform();
    FlutterLinkidGamiPlatform.instance = fakePlatform;

    expect(await flutterLinkidGamiPlugin.getPlatformVersion(), '42');
  });
}
