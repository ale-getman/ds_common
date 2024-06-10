import 'package:ds_common/core/ds_primitives.dart';
import 'package:ds_common/widgets/ds_limited_block.dart';
import 'package:flutter/material.dart';

class DSLimitedText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final TextStyle style;
  final double? maxHeight;
  final double? maxWidth;
  final double marginHeight;
  final double minScale;
  final int groupId;

  const DSLimitedText(this.text, {
    super.key,
    required this.textAlign,
    required this.style,
    this.maxHeight,
    this.maxWidth,
    this.marginHeight = 0,
    this.minScale = 0.3,
    this.groupId = -1,
  }) : assert(minScale > 0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DSLimitedBlock(
          groupId: groupId,
          groupMaxHeight: maxHeight ?? constraints.maxHeight,
          groupMaxWidth: maxWidth ?? constraints.maxWidth,
          minScale: minScale,
          calcHeight: (context, screenWidth, scale) {
            // ToDo: remove
            final textSpan = TextSpan(
              text: text,
              style: style.copyWith(
                fontSize: (style.fontSize ?? 14) * scale,
                height: style.height?.let((v) => (v - 1) * scale + 1),
              ),
            );
            final tp = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            );
            tp.layout(maxWidth: constraints.maxWidth);
            return tp.height + marginHeight * scale;
          },
          calcSize: maxWidth == null ? null : (context, scale) {
            final textSpan = TextSpan(
              text: text,
              style: style.copyWith(
                fontSize: (style.fontSize ?? 14) * scale,
                height: style.height?.let((v) => (v - 1) * scale + 1),
              ),
            );
            final tp = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            );
            tp.layout(maxWidth: constraints.maxWidth);
            tp.dispose();
            return Size(tp.width, tp.height + marginHeight * scale);
          },
          builder: (context, scale) {
            return RichText(
              textAlign: textAlign,
              text: TextSpan(
                text: text,
                style: style.copyWith(
                  fontSize: (style.fontSize ?? 14) * scale,
                  height: style.height?.let((v) => (v - 1) * scale + 1),
                ),
              ),
            );
          },
        );
      },
    );
  }
}