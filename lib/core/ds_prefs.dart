import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

abstract class DSPrefs {
  SharedPreferences? _prefs;
  SharedPreferences get internal => _prefs!;

  static DSPrefs? _instance;

  static DSPrefs get I {
    assert(_instance != null, 'Call DSPrefs() or its subclass before use');
    return _instance!;
  }

  DSPrefs() {
    assert(_instance == null);
    _instance = this;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int getSessionId() => internal.getInt('app_session_id') ?? 0;
  void setSessionId(int value) => internal.setInt('app_session_id', value);

  DateTime getAppLastUsed() =>
      DateTime.fromMillisecondsSinceEpoch((internal.getInt('app_last_used') ?? 0) * 1000);
  void setAppLastUsed(DateTime value) =>
      unawaited(internal.setInt('app_last_used', value.millisecondsSinceEpoch ~/ 1000));

}
