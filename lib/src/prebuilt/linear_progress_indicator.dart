import 'package:animated_progress/src/animated_progress.dart';
import 'package:flutter/material.dart';

/// A animated variant of the classic [LinearProgressIndicator].
/// It behaves the same as the normal [LinearProgressIndicator], but it automatically handles
/// the animation of the progress indicator when the value changes.
class AnimatedLinearProgressIndicator extends StatelessWidget {
  const AnimatedLinearProgressIndicator({
    this.backgroundColor,
    this.color,
    this.minHeight,
    this.semanticsLabel,
    this.semanticsValue,
    this.value,
    this.valueColor,
    super.key,
  });
  final Color? backgroundColor;
  final Color? color;
  final double? minHeight;
  final String? semanticsLabel;
  final String? semanticsValue;
  final double? value;
  final Animation<Color?>? valueColor;
  @override
  Widget build(context) {
    return AnimatedProgress(
      value: value,
      builder: (context, value) {
        return LinearProgressIndicator(
          backgroundColor: backgroundColor,
          color: color,
          key: key,
          minHeight: minHeight,
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
          value: value,
          valueColor: valueColor,
        );
      },
    );
  }
}
