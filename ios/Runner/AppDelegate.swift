import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Add your API key here. Replace the existing key, GMSServices.provideAPIKey(" dsnf")
    GMSServices.provideAPIKey("AIzaSyAP14xUw0sMffll9Vn20eGPbmf2EqH4XJw")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
