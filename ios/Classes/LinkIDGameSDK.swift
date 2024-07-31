import Foundation
import UnityFramework
import LinkIdDigitalFootprintInternal
import linkid_mmp_internal

public protocol GameEventProtocol {
    func onReceiveEvent(_ message: String)
}

public class GameData {
    public var gameName: String = ""
    public var token: String = ""
    public var environment: String = ""
    
    public init() {}
    
    public init(gameName: String, token: String, environment: String) {
        self.gameName = gameName
        self.token = token
        self.environment = environment
    }
}

@objcMembers
public class LinkIDGameSDK: UIResponder, UIApplicationDelegate {
    public static let shared = LinkIDGameSDK()
    private static let devMode: Bool = true
    
    //Digital Footprint
    //UAT
//    private static let tenantId: String = "199"
//    private static let apiKeyDF: String = "a49c9891-ab9c-4b3d-ae7a-420d0b71619c"
    //PRO
    private static let tenantId: String = "69"
    private static let apiKeyDF: String = "59d40bb1-b522-4043-882b-6b3f0a23ada7"
    private static let baseUrlDF: String = "https://digitalfootprint-test.linkid.vn"
    
    //AirFlex
    private static let partnerCodeAirFlex: String = "gamification"
//    private static let appSecretAirFlex: String = "1cdf8788cdc6755eb69792997ab088cf3909ce4d058ac50f3ffe433cf4ef434d"
    private static let appSecretAirFlexPro: String = "4e6a7f73e543ffa3122f181bb46f4a5ba27a2a0ba68f967924f4eee61b4b8773"
    private var launchOpts : [UIApplication.LaunchOptionsKey: Any]?
    private var hostMainWindow : UIWindow?
    
    private var eventListener: GameEventProtocol?
    
    public func setEventProtocol(_ eventProtocol: GameEventProtocol) {
        self.eventListener = eventProtocol
    }
    
#if targetEnvironment(simulator)
#else
    
    private static var isLoadingGame: Bool = false

    // The structure for Unity messages
    private struct UnityMessage {
        let objectName: String?
        let methodName: String?
        let messageBody: String?
    }

    private var cachedMessages = [UnityMessage]() // Array of cached messages

    private let dataBundleId: String = "com.unity3d.framework"
//    private let frameworkPath: String = "/Frameworks/UnityFramework.framework"

    private var ufw : UnityFramework?

    private var isInitialized: Bool {
        ufw?.appController() != nil
    }

    private func initWindow() {
        if isInitialized {
            showWindow()
            return
        }

        guard let ufw = loadUnityFramework() else {
            print("ERROR: Was not able to load Unity")
            return unloadWindow()
        }

        self.ufw = ufw
        ufw.setDataBundleId(dataBundleId)
        ufw.register(self)
        NSClassFromString("FrameworkLibAPI")?.registerAPIforNativeCalls(self)
        ufw.runEmbedded(
            withArgc: CommandLine.argc,
            argv: CommandLine.unsafeArgv,
            appLaunchOpts: nil
        )

        sendCachedMessages() // Added this line
    }

    private func showWindow() {
        if isInitialized {
            ufw?.showUnityWindow()
            sendCachedMessages() // Added this line
        }
    }

    private func unloadWindow() {
        if isInitialized {
            cachedMessages.removeAll() // Added this line
            ufw?.unloadApplication()
        }
    }

    private func loadUnityFramework() -> UnityFramework? {
//        let bundlePath: String = Bundle.main.bundlePath + frameworkPath

//        let bundle = Bundle(path: bundlePath)
        let bundle: Bundle? = Bundle(for: UnityFramework.self)
        if bundle?.isLoaded == false {
            bundle?.load()
        }

        let ufw = bundle?.principalClass?.getInstance()
        if ufw?.appController() == nil {
            let machineHeader = UnsafeMutablePointer<MachHeader>.allocate(capacity: 1)
//            machineHeader.pointee = _mh_execute_header

            ufw?.setExecuteHeader(machineHeader)
        }
        return ufw
    }

    // Main method for sending a message to Unity
    func sendMessage(
        _ objectName: String,
        methodName: String,
        message: String
    ) {
        let msg: UnityMessage = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: message
        )

        // Send the message right away if Unity is initialized, else cache it
        if isInitialized {
            ufw?.sendMessageToGO(
                withName: msg.objectName,
                functionName: msg.methodName,
                message: msg.messageBody
            )
        } else {
            cachedMessages.append(msg)
        }
    }

    // Send all previously cached messages, if any
    private func sendCachedMessages() {
        if cachedMessages.count >= 0 && isInitialized {
            for msg in cachedMessages {
                ufw?.sendMessageToGO(
                    withName: msg.objectName,
                    functionName: msg.methodName,
                    message: msg.messageBody
                )
            }

            cachedMessages.removeAll()
        }
    }
#endif
    public func setLaunchinOptions(_ launchingOptions :  [UIApplication.LaunchOptionsKey: Any]?) {
        self.launchOpts = launchingOptions
    }
    
    public func setHostMainWindow(_ hostMainWindow: UIWindow?) {
        self.hostMainWindow = hostMainWindow
    }
    
    public func show() {
#if targetEnvironment(simulator)
        let alert = UIAlertController(title: "Thông Báo", message: "Game không hỗ trợ máy ảo. Vui lòng dùng máy thật.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            
        }))
        alert.show()
#else
        if isInitialized {
            showWindow()
        } else {
            initWindow()
        }
#endif
    }
    
    public func sendData(_ data: GameData) {
        
#if targetEnvironment(simulator)
        
#else
        //1. check game data
        print("gameName: \(data.gameName) environment: \(data.environment) token: \(data.token)")
        //2. send data to unity
        let msgAES : UnityMessage = UnityMessage(objectName: "GameDock", methodName: "AESFromNative", messageBody: data.token)
        let msgEnvironment : UnityMessage = UnityMessage(objectName: "GameDock", methodName: "SelectEnvironment", messageBody: data.environment)
        let msgGame : UnityMessage = UnityMessage(objectName: "GameDock", methodName: "SelectGame", messageBody: data.gameName)
        ufw?.sendMessageToGO(withName: msgAES.objectName, functionName: msgAES.methodName, message: msgAES.messageBody)
        ufw?.sendMessageToGO(withName: msgEnvironment.objectName, functionName: msgEnvironment.methodName, message: msgEnvironment.messageBody)
        ufw?.sendMessageToGO(withName: msgGame.objectName, functionName: msgGame.methodName, message: msgGame.messageBody)
        
        if data.gameName.isEmpty {
            initSDK(gameName: "gamedefault")
        } else {
            initSDK(gameName: data.gameName)
        }
        
#endif
    }
    
    private func initSDK(gameName:String) {
        
        print("initSDK " + gameName)
        DigitalFootprint.setShowLog(false)
        DigitalFootprint.initSevice(tenantId: LinkIDGameSDK.tenantId, apiKey: LinkIDGameSDK.apiKeyDF, url: LinkIDGameSDK.baseUrlDF);
        Airflex.setDevMode(false)
        Airflex.clear()
        Airflex.intSDK(partnerCode: LinkIDGameSDK.partnerCodeAirFlex, appSecret: LinkIDGameSDK.appSecretAirFlexPro, extra: gameName)
    }
    
    //Private handle eventTracking
    private func handleEventTracking(_ name: String!, message: String!) {
        print("name: " + name + " data: " + message)
        if (name == "showHostMainWindow" || name == "openDeepLink") {
            print("Foward to NEO: " + message)
            if let el = eventListener {
                el.onReceiveEvent(message)
            }
#if targetEnvironment(simulator)
#else
            unloadWindow()
#endif
        } else {
            if let el = eventListener {
                el.onReceiveEvent(message)
            }
        }
    }
}

#if targetEnvironment(simulator)
#else
extension LinkIDGameSDK: UnityFrameworkListener {

    public func unityDidUnload(_ notification: Notification!) {
        ufw?.unregisterFrameworkListener(self)
        ufw = nil
        hostMainWindow?.makeKeyAndVisible()
    }
}
extension LinkIDGameSDK: NativeCallsProtocol {
    public func eventTracking(_ name: String!) {
        print("EventTracking: " + name)
        LinkIDGameSDK.shared.handleEventTracking("onGameTracking", message: name)
    }
    
    public func airFlexEvent(_ gameName: String!) {
        print("airFlexEvent: \(gameName ?? "") ")
        if let data = gameName.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Parse succeed: \(json)")
                    if let eventKey = json["eventKey"] as? String,
                        let key = json["key"] as? String,
                        let value = json["value"] as? String {
                        var map: [String: Any] = [:]
                        map["key"] = key
                        map["value"] = value
                        Airflex.logEvent(name: eventKey, data: map)
                    }
                    }
                }catch {
                    print("Failed to parse JSON: \(error.localizedDescription)")
                }
        } else {
            print("Failed to create Data from JSON string")
        }
//        Airflex.logEvent(name: "event Name", data: ["key" : "value"])
//        LinkIDGameSDK.shared.handleEventTracking(gameName, type: eventKey, data: data)
    }
    
    public func showHostMainWindow(_ message: String) {
        print("showHostMainWindow: " + message)
        LinkIDGameSDK.shared.handleEventTracking("showHostMainWindow", message: message)
    }
}
#endif
