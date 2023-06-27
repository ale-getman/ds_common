import 'dart:async';
import 'dart:ui';

import 'package:ds_common/ds_common.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class DSRemoteConfig {
  final _remoteConfig = FirebaseRemoteConfig.instance;

  var _isInitialized = false;
  var _isFullyInitialized = false;
  var _isInitDone = false;
  var _prefix = '';
  var _postfix = '';

  bool get isInitialized => _isInitialized;
  bool get isFullyInitialized => _isFullyInitialized;

  static DSRemoteConfig? _instance;

  static DSRemoteConfig get I {
    assert(_instance != null, 'Call DSRemoteConfig() or its subclass before use');
    return _instance!;
  }

  DSRemoteConfig({
    required Map<String, dynamic> defaults,
    VoidCallback? onInitialized,
    VoidCallback? onLoaded,
  }) {
    assert(_instance == null);
    _instance = this;
    unawaited(() async {
      final startTime = DateTime.now();
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      await _remoteConfig.setDefaults(defaults);
      await _remoteConfig.ensureInitialized();
      DSMetrica.reportEvent('remote config prestate',
        attributes: _remoteConfig.getAll().map((key, value) => MapEntry('prestate_$key', value.asString())),
      );
      _isInitialized = true;
      onInitialized?.call();

      try {
        await _remoteConfig.fetchAndActivate();
        _isFullyInitialized = true;
      } catch (e, stack) {
        Fimber.e('$e', stacktrace: stack);
      }

      final attrs = _remoteConfig.getAll().map<String, Object>((key, value) => MapEntry(key, value.asString()));
      attrs['remote_config_load_seconds'] = DateTime.now().difference(startTime).inSeconds;
      attrs['remote_config_loaded'] = _isFullyInitialized;
      DSMetrica.reportEvent('remote config loaded', attributes: attrs,);
      _isInitDone = true;
      onLoaded?.call();
    } ());
  }

  Future<void> waitForInit({final maxWait = const Duration(seconds: 5)}) async {
    final start = DateTime.now();
    while (true) {
      if (isInitialized) break;
      if (DateTime.now().difference(start) >= maxWait) {
        Fimber.e('Failed to wait RemoteConfig', stacktrace: StackTrace.current);
        break;
      }
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  Future<void> waitForFullInit({final maxWait = const Duration(seconds: 5)}) async {
    final start = DateTime.now();
    while (true) {
      if (isFullyInitialized) break;
      if (DateTime.now().difference(start) >= maxWait || _isInitDone) {
        Fimber.e('Failed to wait RemoteConfig full load', stacktrace: StackTrace.current);
        break;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void setPrefix(String value) => _prefix = value;
  void setPostfix(String value) => _postfix = value;

  String? _getKey(String key) {
    final all = _remoteConfig.getAll();
    if (_prefix.isNotEmpty || _postfix.isNotEmpty) {
      final sKey = '$_prefix$key$_postfix';
      if (all.containsKey(sKey)) return sKey;
    }
    if (all.containsKey(key)) return key;
    return '';
  }

  bool getBool(String key) {
    final k = _getKey(key);
    if (k == null) return false;
    return _remoteConfig.getBool(k);
  }

  int getInt(String key) {
    final k = _getKey(key);
    if (k == null) return 0;
    return _remoteConfig.getInt(k);
  }

  String getString(String key) {
    final k = _getKey(key);
    if (k == null) return '';
    return _remoteConfig.getString(k);
  }

  Duration getDuration(String key) {
    var res = getInt(key);
    if (res < 0) {
      res = 0;
    }
    return Duration(seconds: res);
  }

  int getUserXPercent() => getInt('userx_percent');
  int getUserXSessions() => getInt('userx_sessions');

}