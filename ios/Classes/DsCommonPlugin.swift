import Flutter
import UIKit

public class DsCommonPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
      let channel = FlutterMethodChannel(name: "ds_common", binaryMessenger: registrar.messenger())
      let instance = DsCommonPlugin()
      registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
        case "getDeviceId":
          result(UIDevice.current.identifierForVendor?.uuidString ?? "")
        default:
          result(FlutterMethodNotImplemented)
      }
    }
}
