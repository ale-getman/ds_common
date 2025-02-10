import 'package:flutter/widgets.dart';

import 'fimber/ds_fimber_base.dart';

typedef DSAppLifecycleStateCallback = void Function(AppLifecycleState? oldState, AppLifecycleState state);

/// Call [DSAppState.preInit] before create application in all cases
abstract class DSAppState {
  static _WidgetsObserver? _widgetsObserver;
  static final _stateCallbacks = <DSAppLifecycleStateCallback>{};

  /// Is [DSAppState] initialized successfully
  static bool get isInitialized => _widgetsObserver != null;

  /// App is in foreground
  static bool get isInForeground => _widgetsObserver!.appLifecycleState! == AppLifecycleState.resumed;

  /// Must be called before create application
  static void preInit() {
    if (isInitialized) {
      Fimber.w('Recall preInit is not needed', stacktrace: StackTrace.current);
      return;
    }

    _widgetsObserver = _WidgetsObserver();
    WidgetsBinding.instance.addObserver(_widgetsObserver!);
    _widgetsObserver!.appLifecycleState = WidgetsBinding.instance.lifecycleState;
  }

  /// Add handler for application state change
  static void registerStateCallback(DSAppLifecycleStateCallback callback) {
    _stateCallbacks.add(callback);
  }

  /// Remove handler for application state change
  static void unregisterStateCallback(DSAppLifecycleStateCallback callback) {
    _stateCallbacks.remove(callback);
  }

}

class _WidgetsObserver with WidgetsBindingObserver {
  AppLifecycleState? appLifecycleState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (appLifecycleState == state) return;
    final old = appLifecycleState;
    appLifecycleState = state;
    for (final callback in DSAppState._stateCallbacks) {
      callback(old, state);
    }
  }
}
