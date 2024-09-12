import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_ad_revenue.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'ds_constants.dart';
import 'ds_metrica.dart';
import 'ds_primitives.dart';

typedef DSAdjustAttribution = AdjustAttribution;
typedef DSAttributionCallback = void Function(DSAdjustAttribution data);

abstract class DSAdjust {
  static var _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static final _attributionCallbacks = <DSAttributionCallback>{};
  static DSAdjustAttribution? _lastAttribution;

  static final _initCallbacks = <void Function()>{};

  static _WidgetsObserver? _widgetsObserver;

  /// Initialize DSAdjust
  /// [adjustKey] - API key of Adjust
  static Future<void> init({
    required String adjustKey,
    bool? launchDeferredDeeplink,
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
    final config = AdjustConfig(
        adjustKey, DSConstants.I.isInternalVersion ? AdjustEnvironment.sandbox : AdjustEnvironment.production);
    config.logLevel = AdjustLogLevel.verbose;
    config.attributionCallback = _setAdjustAttribution;
    config.isDeferredDeeplinkOpeningEnabled = launchDeferredDeeplink;
    Adjust.initSdk(config);

    _isInitialized = true;

    for (final callback in _initCallbacks) {
      callback();
    }
  }

  /// Add callback to be called after initialization
  static addAfterInitCallback(void Function() callback) {
    _initCallbacks.add(callback);
  }

  /// Just Adjust [trackAdRevenueNew] call
  static void trackAdRevenueNew({
    required double value,
    required String currencyCode,
    required String adRevenueNetwork,
    required String adRevenueUnit,
  }) {
    final adRevenue = AdjustAdRevenue('admob_sdk');
    adRevenue.setRevenue(value, currencyCode);
    adRevenue.adRevenueNetwork = adRevenueNetwork;
    adRevenue.adRevenueUnit = adRevenueUnit;
    Adjust.trackAdRevenue(adRevenue);
  }

  /// Result described in https://github.com/adjust/flutter_sdk/blob/master/README.md#af-att-framework
  static Future<num> requestATT() async {
    if (kIsWeb || !Platform.isIOS) return -1;
    final time = Stopwatch()..start();
    final res = await Adjust.requestAppTrackingAuthorization();
    time.stop();
    DSMetrica.reportEvent('AppTrackingTransparency', attributes: {
      'att_result': '$res',
      'att_time_delta_sec': time.elapsed.inSeconds,
      'att_time_delta_ms': time.elapsedMilliseconds,
    });
    return res;
  }

  static Future<String?> getAdid() => Adjust.getAdid();

  /// Result described in https://github.com/adjust/flutter_sdk/blob/master/README.md#af-att-framework
  static Future<int> getATTStatus() async {
    return Adjust.getAppTrackingAuthorizationStatus();
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
