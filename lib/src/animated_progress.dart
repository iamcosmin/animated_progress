import 'package:flutter/widgets.dart';

/// This typedef helps the [AnimatedProgress] code be more cleaner.
typedef _Builder = Widget Function(BuildContext context, double? value);

class AnimatedProgress extends StatelessWidget {
  /// [AnimatedProgress] is a [Widget] that helps you to animate your progress indicator widgets,
  /// such as [CircularProgressIndicator] or [LinearProgressIndicator], which do not have any
  /// animation by default
  ///
  /// This behaves just like a normal widget, but it is recommended to use the provided
  /// [AnimatedCircularProgressIndicator] or [AnimatedLinearProgressIndicator] widgets
  /// for a comfortable experience.
  ///
  /// If you choose to create your own widget, we recommend that you create a custom widget so
  /// that, when you will reuse it, your code will be more cleaner.
  ///
  /// Here is an example of how you can use this widget.
  ///
  /// ```dart
  /// class CustomAnimatedProgressIndicator extends StatelessWidget {
  ///  const CustomAnimatedProgressIndicator({
  ///   /// Insert here any parameters that you want to pass down to your custom widget.
  ///   this.value,
  ///   super.key,
  ///  });
  ///
  ///  /// The progress indicator value that you will ONLY pass down to the [AnimatedProgress] widget.
  ///  ///
  ///  /// You WILL NOT use it in the builder method of [AnimatedProgress]
  ///  final double? value;
  ///
  ///  @override
  ///  Widget build(context) {
  ///   return AnimatedProgress(
  ///     /// You can always provide a custom [animationDuration] or [curve].
  ///     builder: (context, value) {
  ///       // Return your non-animated widget here and use the value provided by the builder.
  ///       // DO NOT use the value that the widget passed you, otherwise the animation
  ///       // may not be present.
  ///       return LinearProgressIndicator(
  ///         value: value,
  ///         // Here, you can customize any parameters you like.
  ///        );
  ///       },
  ///     );
  ///   }
  /// }
  /// ```
  ///
  /// Then, in your app.
  ///
  /// ```dart
  /// child: CustomAnimatedProgressIndicator(
  ///   /// Changing the value from the state will always auto-handle the smooth animation between
  ///   /// values.
  ///   value: 0.5
  /// ),
  /// ```
  ///
  /// See also:
  /// * [AnimatedCircularProgressIndicator], which is a clone of [CircularProgressIndicator] that
  /// automatically handles the animation when you change the value.
  /// * [AnimatedLinearProgressIndicator], which is a clone of [LinearProgressIndicator] that
  /// automatically handles the animation when you change the value.
  const AnimatedProgress({
    required this.builder,
    this.value,
    this.animationDuration = const Duration(seconds: 1),
    this.curve = Curves.fastOutSlowIn,
    super.key,
  });

  /// [value] is the argument that you need to provide to make the magic happen. Just change the
  /// state of the [value] and the widget will automagically handle the animation.
  ///
  /// As we already said in the [builder] documentation, please make sure that you are not
  /// providing this [value] to the widget that you are returning from the [builder], otherwise
  /// you will not have a animation.
  final double? value;

  /// [animationDuration] modifies, you guessed it, the duration of the [Tween] animation.
  ///
  /// By default, this has a duration of 1 second (to align with material specs but also to give
  /// it a pleasant yet fast animation), but you can always modify this to anything you would like.
  final Duration animationDuration;

  /// [curve] modifies the [Curve] of the animation. If you don't know what a [Curve] is, look into
  /// the documentation.
  ///
  /// By default, the curve that the animation uses is [Curves.fastOutSlowIn] (to align with
  /// material specs but also to give it a pleasant yet smooth animation). Of course, you are
  /// always free to modify this to anything you would like.
  final Curve curve;

  /// [builder] is the method that will help you animate your progress indicator.
  ///
  /// This method provides 2 arguments, a context and a value. The most important argument is
  /// the value. You need to provide the value argument to the progress indicator widget so that
  /// the widget can animate properly.
  ///
  /// A frequent mistake that people make is they pass down to their progress indicator a value
  /// that is not provided by this method. This makes the indicator not animate.
  ///
  /// If your indicator does not animate, please make sure that you are using the correct value
  /// in your progress indicator widget.
  // ignore: library_private_types_in_public_api
  final _Builder builder;

  /// Good old [tween]. This is used to animate the value of the [builder] method.
  /// We are considering that you don't need to modify the tween, so we didn't put it in the
  /// constructor of the widget.
  ///
  /// If you really need to modify this value, you can always make your own widget based on this
  /// source code. Or better, come up with a better way to provide [tween] in the constructor
  /// without making it unconstant and submit a pull request to this repo. We will greatly
  /// appreciate it.
  Tween get tween => Tween<double>(begin: 0, end: value);

  @override
  Widget build(BuildContext context) {
    if (value != null) {
      return TweenAnimationBuilder(
        tween: tween,
        duration: animationDuration,
        curve: curve,
        builder: (context, value, child) {
          return builder(context, value as double?);
        },
      );
    } else {
      return builder(context, null);
    }
  }
}
