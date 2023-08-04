import Flutter
import UIKit
import UserXKit

public class DsCommonPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "pro.altush.ds_common/metrica", binaryMessenger: registrar.messenger())
    let instance = DsCommonPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      // This method is invoked on the UI thread
      switch (call.method) {
      case "setUserXScreenName":
          let screenName = (call.arguments as? String)!
          UserX.startScreen(named: screenName)
          result(nil)
      default:
          result(FlutterMethodNotImplemented)
      }
  }
}
