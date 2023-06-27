import 'dart:async';
import 'dart:ui';

import 'package:fimber/fimber.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'ds_logging.dart';

class DSConstants {
  static bool get isInitialized => _instance?._isInitialized ?? false;

  static DSConstants? _instance;

  static DSConstants get I {
    assert(_instance != null, 'Call DSConstants(...) or its subclass before use');
    return _instance!;
  }

  DSConstants({required VoidCallback? then}) {
    assert(_instance == null);
    _instance = this;
    unawaited(() async {
      packageInfo = await PackageInfo.fromPlatform();
      // 3-number builds are internal (ex 1.4.12)
      if (packageInfo.version.split('.').length == 3) {
        logDebug('INTERNAL VERSION: ${packageInfo.version}');
        _isInternalVersion = true;
      }
      _isInitialized = true;
      then?.call();
    }());
  }

  var _isInitialized = false;
  var _isInternalVersion = false;

  bool get isInternalVersion {
    if (!_isInitialized) {
      const err = 'Wait for init';
      assert(false, err);
      Fimber.e(err, stacktrace: StackTrace.current);
    }
    return _isInternalVersion;
  }
  bool get isProductionAds => !isInternalVersion;

  late final PackageInfo packageInfo;
}