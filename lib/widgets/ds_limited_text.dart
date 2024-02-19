import 'dart:math';

import 'package:ds_common/core/ds_primitives.dart';
import 'package:flutter/material.dart';

class DSLimitedText extends StatefulWidget {
  final String text;
  final TextAlign textAlign;
  final TextStyle style;
  final double maxHeight;
  final double decreaseStep;
  final double minScale;

  const DSLimitedText(this.text, {
    super.key,
    required this.textAlign,
    required this.style,
    required this.maxHeight,
    this.decreaseStep = 0.03,
    this.minScale = 0.3,
  }) : assert(minScale > 0),
        assert(decreaseStep > 0 && decreaseStep < 1);

  @override
  State<DSLimitedText> createState() => _DSLimitedTextState();
}

class _DSLimitedTextState extends State<DSLimitedText> {
  double? _scale;

  @override
  void didUpdateWidget(covariant DSLimitedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scale = null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_scale == null) {
          _scale = 1;
          while (_scale! > widget.minScale) {
            final textSpan = TextSpan(
              text: widget.text,
              style: widget.style.copyWith(
                fontSize: (widget.style.fontSize ?? 14) * _scale!,
                height: widget.style.height?.let((v) => (v - 1) * _scale! + 1),
              ),
            );
            final tp = TextPainter(
                text: textSpan,
                textDirection: TextDirection.ltr,
            );
            tp.layout(maxWidth: constraints.maxWidth);
            if (tp.height <= min(widget.maxHeight, constraints.maxHeight)) break;
            _scale = _scale! - widget.decreaseStep;
          }
        }
        return RichText(
          textAlign: widget.textAlign,
          text: TextSpan(
            text: widget.text,
            style: widget.style.copyWith(
              fontSize: (widget.style.fontSize ?? 14) * _scale!,
              height: widget.style.height?.let((v) => (v - 1) * _scale! + 1),
            ),
          ),
        );
      },
    );
  }
}