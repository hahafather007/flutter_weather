import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private final let CHANNEL_NAME = "flutter_weather_channel"
    private final let START_LOCATION = "weatherStartLocation"
    private final let SEND_EMAIL = "weatherSendEmail"
    
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
            switch (call.method) {
            case self.START_LOCATION:
                self.locationHolder.startLocation(result: result)
                break
            case self.SEND_EMAIL:
                let map = call.arguments as! [String:String?]
                result(FeedbackUtil.sendEmail(email: map["email"]!!))
                break
            default:
                result(FlutterMethodNotImplemented)
                break
            }
        })
    }
}
