import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private final let CHANNEL_NAME = "flutter_weather_channel"
    private final let START_LOCATION = "startLocation"
    
    private let locationHolder = LocationHolder()
    
    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        initMethodChannel()
    
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func initMethodChannel() {
        let controller = window?.rootViewController as! FlutterViewController;
        let channel = FlutterMethodChannel.init(name: CHANNEL_NAME, binaryMessenger: controller);
        
        channel.setMethodCallHandler({ (call, result) -> Void in
            if (call.method == self.START_LOCATION) {
                self.locationHolder.startLocation(result: result)
            }
        })
    }
}
