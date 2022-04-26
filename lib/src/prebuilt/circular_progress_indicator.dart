import 'package:animated_progress/src/animated_progress.dart';
import 'package:flutter/material.dart';

/// A animated variant of the classic [CircularProgressIndicator].
/// It behaves the same as the normal [CircularProgressIndicator], but it automatically handles
/// the animation of the progress indicator when the value changes.
class AnimatedCircularProgressIndicator extends StatelessWidget {
  const AnimatedCircularProgressIndicator({
    this.backgroundColor,
    this.color,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = 4.0,
    this.value,
    this.valueColor,
    super.key,
  });
  final Color? backgroundColor;
  final Color? color;
  final String? semanticsLabel;
  final String? semanticsValue;
  final double strokeWidth;
  final double? value;
  final Animation<Color?>? valueColor;
  @override
  Widget build(context) {
    return AnimatedProgress(
      value: value,
      builder: (context, value) {
        return CircularProgressIndicator(
          backgroundColor: backgroundColor,
          color: color,
          key: key,
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
          strokeWidth: strokeWidth,
          value: value,
          valueColor: valueColor,
        );
      },
    );
  }
}
