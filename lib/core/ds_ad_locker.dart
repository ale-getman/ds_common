import 'ds_primitives.dart';

class DSAdLocker {
  static var _appOpenLockedUntil = DateTime(0);
  static var _appOpenLockedUntilAppResumed = false;

  static bool get isAppOpenLocked => _appOpenLockedUntilAppResumed
      || DateTime.timestamp().compareTo(_appOpenLockedUntil) < 0;


  static void appOpenLockUntilAppResume() {
    _appOpenLockedUntilAppResumed = true;
  }

  static void appOpenUnlockUntilAppResume({Duration? andLockFor}) {
    _appOpenLockedUntilAppResumed = false;
    andLockFor?.let((it) => appOpenLockShowFor(it));
  }

  static void appOpenLockShowFor(Duration duration) {
    _appOpenLockedUntil = DateTime.timestamp().add(duration);
  }


}