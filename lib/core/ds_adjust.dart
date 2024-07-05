import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/widgets.dart';

import 'ds_constants.dart';
import 'ds_primitives.dart';

typedef DSAdjustAttribution = AdjustAttribution;
typedef DSAttributionCallback = void Function(DSAdjustAttribution data);

abstract class DSAdjust {
  static var _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static final _attributionCallbacks = <DSAttributionCallback>{};
  static DSAdjustAttribution? _lastAttribution;

  static _WidgetsObserver? _widgetsObserver;

  /// Initialize DSAdjust
  /// [adjustKey] - API key of Adjust
  static Future<void> init({
    required String adjustKey,
  }) async {
    if (_isInitialized) {
      Fimber.e('DSAdjust is already initialised', stacktrace: StackTrace.current);
      return;
    }

    assert(_widgetsObserver == null);
    _widgetsObserver = _WidgetsObserver();
    WidgetsBinding.instance.addObserver(_widgetsObserver!);
    _widgetsObserver!.appLifecycleState = WidgetsBinding.instance.lifecycleState;

    await DSConstants.I.waitForInit();
    final config = AdjustConfig(adjustKey, DSConstants.I.isInternalVersion
        ? AdjustEnvironment.sandbox
        : AdjustEnvironment.production
    );
    config.logLevel = AdjustLogLevel.verbose;
    config.attributionCallback = _setAdjustAttribution;
    Adjust.start(config);

    _isInitialized = true;
  }

  /// Add handler for Adjust -> attributionCallback
  static void registerAttributionCallback(DSAttributionCallback callback) {
    _attributionCallbacks.add(callback);
    _lastAttribution?.let((it) => callback(it));
  }

  /// Remove handler for Adjust -> attributionCallback
  static void unregisterAttributionCallback(DSAttributionCallback callback) {
    _attributionCallbacks.remove(callback);
  }

  static void _setAdjustAttribution(AdjustAttribution data) {
    _lastAttribution = null;
    for (final callback in _attributionCallbacks) {
      callback(data);
    }
    _lastAttribution = data;
  }

}

class _WidgetsObserver with WidgetsBindingObserver {
  AppLifecycleState? appLifecycleState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (appLifecycleState == state) return;
    appLifecycleState = state;
    switch (state) {
      case AppLifecycleState.resumed:
        Adjust.onResume();
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        break;
      default:
        break;
    }
  }
}
