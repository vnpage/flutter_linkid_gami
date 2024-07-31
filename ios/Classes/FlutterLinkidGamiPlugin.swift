import Flutter
import UIKit

public class FlutterLinkidGamiPlugin: NSObject, FlutterPlugin, GameEventProtocol {
    
    var channel: FlutterMethodChannel?
    public static let sharedInstance = FlutterLinkidGamiPlugin()
    
    private override init() {
        super.init()
    }
    
    public func onReceiveEvent(_ message: String) {
        print("onReceiveEvent: \(message)")
        channel?.invokeMethod("onEventTracking", arguments: message)
    }
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
      let instance = FlutterLinkidGamiPlugin.sharedInstance
      instance.channel = FlutterMethodChannel(name: "flutter_linkid_gami", binaryMessenger: registrar.messenger())
      registrar.addMethodCallDelegate(instance, channel: instance.channel!)
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
        if let args = call.arguments as? [String: Any] {
            if let gameName = args["gameName"] as? String,
            let token = args["token"] as? String,
               let environment = args["environment"] as? String {
                result("iOS " + "gameName: \(gameName), token: \(token), environment: \(environment)")
                let gameData: GameData = GameData(gameName: gameName, token: token, environment: environment)
                LinkIDGameSDK.shared.setEventProtocol(self)
                LinkIDGameSDK.shared.sendData(gameData)
            }
        }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
