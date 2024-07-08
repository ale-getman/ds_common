## 0.1.21
- expand Adjust methods list

## 0.1.20
- add DSAdjust (Adjust library integration)
- minor code quality improvements

## 0.1.19
- fix web platform checks
- add DSConstants.isInternalVersionOpt for uninitialized access

## 0.1.18
- fix DSLimitedText exception

## 0.1.17
- add AppMetrica.setUserProfileID
- add DSLimitedBlock.calcSize method (experimental)
- add exceptions logging for yandexId initialization

## 0.1.16
- allow to exclude duplicated and non-informative exceptions from logging in DSCrashReportingTree

## 0.1.15
- add DSLimitedBlock widget
- add FirebaseAnalytics optional events (fbSend parameter of DSMetrica.reportEvent)
- add AppMetrica putErrorEnvironmentValue wrapper
- UserX updated

## 0.1.14
- add DSLimitedText widget

## 0.1.13
- add method internalInit to DSConstants

## 0.1.12
- add web support
- add "let" extension (like in Kotlin)

## 0.1.11
- fixed first start with no internet connection

## 0.1.10
- add user_time attribute to reportEvent

## 0.1.9
- improve stack logging for unawaitedCatch

## 0.1.8
- update UserX to 1.1.0 (previous versions of ds_common are incompatible with UserX 1.1.0)

## 0.1.7
- add optional debug mode sending to DSMetrica
- add dynamic PersistentAttrs (DSMetrica.setPersistentAttrsHandler)

## 0.1.6
- build fixed

## 0.1.5
- add reportScreenOpened method
- update AppMetrica plugin min version
- add some documentation

## 0.1.4
- DSPrefs now is a ChangeNotifier

## 0.1.3
- disable text highlighting for iOS logging

## 0.1.2
- dependencies updated

## 0.1.1
- DSMetrica initialization fixed

## 0.1.0
- implements Metrica, Firebase Crashlytics, RemoteConfig, Fimber and Shared Preferences support