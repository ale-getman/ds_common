extension ObjExtenstions<T> on T {
  /// [let] call inspired by Kotlin
  R let<R>(R Function(T that) op) => op(this);
}
