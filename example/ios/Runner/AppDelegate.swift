import Flutter
import UIKit
import flutter_linkid_gami

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      LinkIDGameSDK.shared.setHostMainWindow(window)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
