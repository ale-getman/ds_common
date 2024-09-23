import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class DSInternal {
  @internal
  static const platform = MethodChannel('ds_common');
}