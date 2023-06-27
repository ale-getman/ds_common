import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'ds_logging.dart';
import 'ds_metrica.dart';

class DSDebugTree extends DebugTree {

  static final Map<String, DSAnsiColor> _colorizeMap = {
    'V': DSAnsiColor.fg(DSAnsiColor.grey(0.5)),
    'D': DSAnsiColor.fg(96),
    'I': DSAnsiColor.fg(12),
    'W': DSAnsiColor.fg(208),
    'E': DSAnsiColor.fg(196),
  };

  final bool useColors;

  DSDebugTree({
    logLevels = DebugTree.defaultLevels,
    this.useColors = true,
  }) : super(logLevels: logLevels);


  @override
  void printLog(String logLine, {String? level}) {
    assert(printTimeType == DebugTree.timeClockType);
    final colorizeTransform = (level != null && useColors) ? _colorizeMap[level] : null;
    var date = DateTime.now().toIso8601String();
    var isFirst = true;
    logLine.split('\n').forEach((line) {
      var printableLine = line;
      if (isFirst) {
        isFirst = false;
        printableLine = '$date\t$line';
      }
      if (colorizeTransform != null) {
        debugPrint(colorizeTransform(printableLine));
      } else {
        debugPrint(printableLine);
      }
    });
  }
}

class DSCrashReportingTree extends LogTree {
  // Only Log Warnings and Exceptions
  static const defaultLevels = <String>['W', 'E'];
  // Same values as android.util.Log
  static const _priorities = <String, int>{
    'V': 2,
    'D': 3,
    'I': 4,
    'W': 5,
    'E': 6,
  };
  final List<String> logLevels;

  @override
  List<String> getLevels() => logLevels;

  DSCrashReportingTree({this.logLevels = defaultLevels});

  @override
  void log(String level, String message, {String? tag, dynamic ex, StackTrace? stacktrace}) {
    FirebaseCrashlytics.instance.setCustomKey('priority', _priorities[level] ?? 0);
    FirebaseCrashlytics.instance.recordError('[$level] $message', stacktrace);
    FirebaseCrashlytics.instance.setCustomKey('priority', -1);

    if (!message.contains('failed to connect to yandex')) {
      unawaited(DSMetrica.reportError(
        message: '[$level] $message',
        errorDescription: stacktrace != null
            ? AppMetricaErrorDescription(stacktrace, message: message, type: '[$level]')
            : null,
      ));
      final limStack = LimitedStackTrace(
        stackTrace: stacktrace ?? StackTrace.empty,
        deep: 4,
      );
      DSMetrica.reportEvent('[$level] $message', attributes: {
        'error_priority': _priorities[level] ?? 0,
        'stack': '$limStack',
      });
    }
  }
}
