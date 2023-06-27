// Based on https://iiro.dev/2020/05/18/restricting-system-text-scale-factor/

import 'dart:math';

import 'package:flutter/material.dart';

import '../core/ds_metrica.dart';

class DSScaleLimiter extends StatelessWidget {

  const DSScaleLimiter({
    Key? key,
    required this.child,
    this.minFactor = 0.9,
    this.maxFactor = 1.2,
    this.minWidth = 360,
  }) : super(key: key);

  final Widget child;
  final double minFactor;
  final double maxFactor;
  final double minWidth;

  static var _statSendFactor = 0.0;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final origFactor = mediaQueryData.textScaleFactor;
    var newFactor = origFactor.clamp(minFactor, maxFactor);

    // ToDo: try to find good solution for devicePixelRatio (Display size, not Font size)
    final width = min(mediaQueryData.size.width, mediaQueryData.size.height);
    if (width < minWidth) {
      newFactor = newFactor *  width / minWidth;
    }

    if (_statSendFactor != newFactor) {
      _statSendFactor = newFactor;
      final attrs = {
        'text_scale_factor': origFactor,
        if (newFactor != origFactor)
          'text_scale_factor_corrected': newFactor,
        'screen_size_width': mediaQueryData.size.width,
        'screen_size_height': mediaQueryData.size.height,
      };
      if (origFactor == 1) {
        DSMetrica.reportEvent('text scale factor (standard)', attributes: attrs);
      } else {
        DSMetrica.reportEvent('text scale factor (non-standard)', attributes: attrs);
      }
    }

    return MediaQuery(
      data: mediaQueryData.copyWith(
        textScaleFactor: newFactor,
      ),
      child: child,
    );
  }
}