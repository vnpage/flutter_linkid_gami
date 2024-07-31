import Flutter
import UIKit

public class FlutterLinkidGamiPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_linkid_gami", binaryMessenger: registrar.messenger())
    let instance = FlutterLinkidGamiPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "initSDK":
      result("iOS " + UIDevice.current.systemVersion)
//        LinkIDGameSDK.shared.sendData(<#T##data: GameData##GameData#>)
    case "showGame":
        LinkIDGameSDK.shared.show()
      result(true)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
