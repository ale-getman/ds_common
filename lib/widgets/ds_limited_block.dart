import 'dart:math';

import 'package:flutter/widgets.dart';

class DSLimitedBlock extends StatefulWidget {
  final int groupId;
  /// negative value means than use another [groupMaxHeight] of this group
  final double groupMaxHeight;
  final double groupMaxWidth;
  final double Function(BuildContext context, double screenWidth, double scale) calcHeight;
  final Size Function(BuildContext context, double scale)? calcSize;
  final Widget Function(BuildContext context, double scale) builder;
  final double minScale;

  const DSLimitedBlock({
    super.key,
    this.groupId = -1,
    required this.groupMaxHeight,
    required this.calcHeight,
    required this.builder,
    this.groupMaxWidth = double.maxFinite,
    this.minScale = 0.3,
    this.calcSize,
  }): assert(minScale > 0);

  @override
  State<DSLimitedBlock> createState() => _DSLimitedBlockState();
}

class _GroupInfo {
  final states = <_DSLimitedBlockState>[];
  double scale = 0;
}

class _DSLimitedBlockState extends State<DSLimitedBlock> {
  static final _groups = <int, _GroupInfo>{};
  double _localScale = 0;

  void invalidateGroup() {
    if (widget.groupId < 0) {
      setState(() {});
      return;
    }
    final group = _groups[widget.groupId];
    if (group == null) return;
    group.scale = 0;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      for (final e in group.states) {
        e.setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.groupId >= 0) {
      _groups[widget.groupId] ??= _GroupInfo();
      invalidateGroup();
      final group = _groups[widget.groupId]!;
      group.states.add(this);
    }
  }

  @override
  void didUpdateWidget(covariant DSLimitedBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.groupId != widget.groupId) {
      _localScale = 0;
      if (oldWidget.groupId >= 0) {
        _groups[oldWidget.groupId]?.states.remove(this);
        _groups[oldWidget.groupId]?.scale = 0;
      }
      invalidateGroup();
      if (widget.groupId >= 0) {
        _groups[widget.groupId]?.states.add(this);
      }
    }
  }

  @override
  void dispose() {
    if (widget.groupId >= 0) {
      _groups[widget.groupId]?.states.remove(this);
      invalidateGroup();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _GroupInfo? group;
    if (widget.groupId >= 0) {
      group = _groups[widget.groupId]!;
      _localScale = group.scale;
    } else {
      group = null;
    }
    if (_localScale == 0) {
      final size = MediaQuery.of(context).size;
      final maxHeight = group?.states.fold<double>(double.maxFinite, (p, s) {
        final h = s.widget.groupMaxHeight;
        if (h <= 0) return p;
        return min(p, h);
      }) ?? widget.groupMaxHeight;
      _localScale = 1;
      while (_localScale > widget.minScale) {
        final height = (group?.states ?? [this]).fold<double>(0, (p, s) {
          return p + s.widget.calcHeight(context, size.width, _localScale);
        });
        if (height <= maxHeight) break;
        _localScale /= sqrt(height / maxHeight);
        _localScale -= 0.001;
      }

      if (widget.calcSize != null) {
        final maxWidth = group?.states.fold<double>(double.maxFinite, (p, s) {
          final h = s.widget.groupMaxWidth;
          if (h <= 0) return p;
          return min(p, h);
        }) ?? widget.groupMaxWidth;

        while (_localScale > widget.minScale) {
          final size = (group?.states ?? [this]).fold<Size>(Size.zero, (p, w) {
            if (w.widget.calcSize == null) return p;
            final s = w.widget.calcSize!(context, _localScale);
            return Size(max(s.width, p.width), p.height + s.height);
          });
          if (size.height <= maxHeight && size.width <= maxWidth) break;
          _localScale /= max(sqrt(size.height / maxHeight), sqrt(size.width / maxWidth));
          _localScale -= 0.001;
        }
      }

      group?.scale = _localScale;
    }

    return widget.builder(context, _localScale);
  }
}
