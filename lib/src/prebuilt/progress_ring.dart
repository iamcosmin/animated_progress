import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../animated_progress.dart';

const double _kMinProgressRingIndicatorSize = 36.0;

/// A progress control provides feedback to the user that a
/// long-running operation is underway. It can mean that the
/// user cannot interact with the app when the progress indicator
/// is visible, and can also indicate how long the wait time might be.
///
/// ![Determinate Progress Ring](https://docs.microsoft.com/en-us/windows/uwp/design/controls-and-patterns/images/progress_ring.jpg)
/// ![Indeterminate Progress Ring](https://docs.microsoft.com/en-us/windows/uwp/design/controls-and-patterns/images/progressring-indeterminate.gif)
class ProgressRing extends StatefulWidget {
  /// Creates progress ring.
  ///
  /// [value], if non-null, must be in the range of 0 to 100
  ///
  /// [strokeWidth] must be equal or greater than 0
  const ProgressRing({
    Key? key,
    this.value,
    this.strokeWidth = 4.5,
    this.semanticLabel,
    this.backgroundColor,
    this.foregroundColor,
    this.backwards = false,
    this.animationDuration,
    this.curve,
  })  : assert(value == null || value >= 0 && value <= 100),
        super(key: key);

  /// The current value of the indicator. If non-null, produces
  /// the following:
  ///
  /// ![Determinate Progress Ring](https://docs.microsoft.com/en-us/windows/uwp/design/controls-and-patterns/images/progress_ring.jpg)
  ///
  /// If null, an indeterminate progress ring is created:
  ///
  /// ![Indeterminate Progress Ring](https://docs.microsoft.com/en-us/windows/uwp/design/controls-and-patterns/images/progressring-indeterminate.gif)
  final double? value;

  /// The stroke width of the progress ring. If null, defaults to 4.5 logical pixels
  final double strokeWidth;
  final String? semanticLabel;

  /// The background color of the progress ring. If null,
  /// [ThemeData.inactiveColor] is used
  final Color? backgroundColor;

  /// The active color of the progress ring. If null,
  /// [ThemeData.colorScheme.primary] is used
  final Color? foregroundColor;

  /// Whether the indicator spins backwards or not. Defaults to false
  final bool backwards;

  /// The duration of the animation from between states. Defaults to
  /// [Duration(seconds: 1)]
  final Duration? animationDuration;

  /// The curve of the animation from between states. Defaults to
  /// [Curves.fastOutSlowIn]
  final Curve? curve;

  @override
  State<ProgressRing> createState() => _ProgressRingState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value, ifNull: 'indeterminate'));
    properties.add(DoubleProperty('strokeWidth', strokeWidth));
  }
}

class _ProgressRingState extends State<ProgressRing>
    with SingleTickerProviderStateMixin {
  static final TweenSequence<double> _startAngleTween = TweenSequence([
    TweenSequenceItem(
      tween: Tween<double>(
        begin: 0,
        end: 450,
      ),
      weight: 1,
    ),
    TweenSequenceItem(
      tween: Tween<double>(
        begin: 450,
        end: 1080,
      ),
      weight: 1,
    ),
  ]);
  static final TweenSequence<double> _sweepAngleTween = TweenSequence([
    TweenSequenceItem(
      tween: Tween<double>(
        begin: 0,
        end: 180,
      ),
      weight: 1,
    ),
    TweenSequenceItem(
      tween: Tween<double>(
        begin: 180,
        end: 0,
      ),
      weight: 1,
    ),
  ]);

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    if (widget.value == null) _controller.repeat();
  }

  @override
  void didUpdateWidget(ProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: _kMinProgressRingIndicatorSize,
        minHeight: _kMinProgressRingIndicatorSize,
      ),
      child: Semantics(
        label: widget.semanticLabel,
        value: widget.value?.toStringAsFixed(2),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return AnimatedProgress(
              animationDuration:
                  widget.animationDuration ?? const Duration(seconds: 1),
              curve: widget.curve ?? Curves.fastOutSlowIn,
              value: widget.value,
              builder: (context, value) {
                return CustomPaint(
                  painter: _RingPainter(
                    backgroundColor: const Color(0x00000000),
                    value: value,
                    color: widget.foregroundColor ??
                        Theme.of(context).colorScheme.primary,
                    strokeWidth: widget.strokeWidth,
                    startAngle: _startAngleTween.evaluate(_controller),
                    sweepAngle: _sweepAngleTween.evaluate(_controller),
                    backwards: widget.backwards,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;
  final double? value;
  final double startAngle, sweepAngle;
  final bool backwards;

  const _RingPainter({
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.value,
    required this.startAngle,
    required this.sweepAngle,
    required this.backwards,
  });

  static const double _twoPi = math.pi * 2.0;
  static const double _epsilon = .001;
  // Canvas.drawArc(r, 0, 2*PI) doesn't draw anything, so just get close.
  static const double _sweep = _twoPi - _epsilon;
  static const double _startAngle = -math.pi / 2.0;
  static const double _deg2Rad = (2 * math.pi) / 360;

  @override
  void paint(Canvas canvas, Size size) {
    // Background line
    canvas.drawArc(
      Offset.zero & size,
      _startAngle,
      100,
      false,
      Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    if (value == null) {
      canvas.drawArc(
        Offset.zero & size,
        ((backwards ? -startAngle : startAngle) - 90) * _deg2Rad,
        sweepAngle * _deg2Rad,
        false,
        paint,
      );
    } else {
      canvas.drawArc(
        Offset.zero & size,
        _startAngle,
        (value! / 100).clamp(0, 1) * _sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      value == null || value != oldDelegate.value;

  @override
  bool shouldRebuildSemantics(_RingPainter oldDelegate) => false;
}
