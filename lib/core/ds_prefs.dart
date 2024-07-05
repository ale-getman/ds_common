import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart' as meta;

abstract class DSPrefs extends ChangeNotifier {
  SharedPreferences? _prefs;
  SharedPreferences get internal => _prefs!;

  static DSPrefs? _instance;

  static DSPrefs get I {
    assert(_instance != null, 'Call DSPrefs() or its subclass before use');
    return _instance!;
  }

  DSPrefs() {
    assert(_instance == null);
    _instance ??= this;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void notifyAsync() {
    Timer.run(() {
      notifyListeners();
    });
  }

  @protected
  void setBool(String key, bool value) {
    internal.setBool(key, value);
    notifyAsync();
  }

  @protected
  void setInt(String key, int value) {
    internal.setInt(key, value);
    notifyAsync();
  }

  @protected
  void setDouble(String key, double value) {
    internal.setDouble(key, value);
    notifyAsync();
  }

  @protected
  void setString(String key, String value) {
    internal.setString(key, value);
    notifyAsync();
  }

  @protected
  void setStringList(String key, List<String> value) {
    internal.setStringList(key, value);
    notifyAsync();
  }

  @protected
  void remove(String key) {
    internal.remove(key);
    notifyAsync();
  }

  int getSessionId() => internal.getInt('app_session_id') ?? 0;
  // ignore:invalid_internal_annotation
  @meta.internal
  /// Use [DSMetrica.tryUpdateAppSessionId] instead
  void setSessionId(int value) => setInt('app_session_id', value);

  DateTime getAppLastUsed() =>
      DateTime.fromMillisecondsSinceEpoch((internal.getInt('app_last_used') ?? 0) * 1000);
  void setAppLastUsed(DateTime value) => setInt('app_last_used', value.millisecondsSinceEpoch ~/ 1000);

  bool isYandexDeviceIdSent() => internal.getBool('yandexDeviceIdSent') ?? false;
  void setYandexDeviceIdSent(bool value) => setBool('yandexDeviceIdSent', value);
}
