part of treebuilder;

/// [SizeAnimation] will run a size animation on a child widget
class SizeAnimation extends StatelessWidget {
  /// widget to apply animation to
  final Widget child;

  /// value to start the animation at
  ///
  /// Default is 0.0. i.e. no size
  final double tweenBegin;

  /// value to end the animation at
  ///
  /// Default is 1.0. i.e. full size
  final double tweenEnd;

  /// the duration of the animation in milliseconds
  ///
  /// Defaults to 300ms.
  final int animationDurationMs;

  /// the curve to apply to the animation
  ///
  /// defaults to [Curves.fastOutSlowIn]
  final Curve animationCurve;

  /// direction to run animation in
  ///
  /// defaults to true
  final bool forward;

  const SizeAnimation({
    Key? key,
    required this.child,
    this.tweenBegin = 0.0,
    this.tweenEnd = 1.0,
    this.animationDurationMs = 300,
    this.animationCurve = Curves.fastOutSlowIn,
    this.forward = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DoubleAnimation(
      tweenBegin: tweenBegin,
      tweenEnd: tweenEnd,
      animationDurationMs: animationDurationMs,
      animationCurve: animationCurve,
      forward: forward,
      builder: (_, doubleTween) {
        return SizeTransition(
          sizeFactor: doubleTween,
          axisAlignment: -1.0,
          child: child,
        );
      },
    );
  }
}
