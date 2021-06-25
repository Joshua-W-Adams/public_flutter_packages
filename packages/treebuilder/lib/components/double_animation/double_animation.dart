part of treebuilder;

/// [DoubleAnimation] is a creates and manages an animation that animates a
/// tween between a start and end double value.
class DoubleAnimation extends StatefulWidget {
  /// widget builder to apply size animation to
  final Widget Function(BuildContext context, Animation<double> doubleTween)
      builder;

  /// value to start the size animation at
  ///
  /// Default is 0.0. i.e. no size.
  final double tweenBegin;

  /// value to end the size animation at
  ///
  /// Default is 1.0. i.e. full size.
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

  DoubleAnimation({
    required this.builder,
    this.tweenBegin = 0.0,
    this.tweenEnd = 1.0,
    this.animationDurationMs = 300,
    this.animationCurve = Curves.fastOutSlowIn,
    this.forward = true,
  });

  @override
  _DoubleAnimationState createState() => _DoubleAnimationState();
}

class _DoubleAnimationState extends State<DoubleAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;
  bool? _forward;

  @override
  void initState() {
    super.initState();

    /// configure animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.animationDurationMs,
      ),
    );
    Animation<double> curve = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );

    /// configure animation
    _animation = Tween<double>(
      begin: widget.tweenBegin,
      end: widget.tweenEnd,
    ).animate(curve);

    _runAnimation();
  }

  @override
  void didUpdateWidget(DoubleAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runAnimation();
  }

  void _runAnimation() {
    /// only run animation if the direction has changed
    if (_forward != widget.forward) {
      if (widget.forward) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }

    /// store last animated direction
    _forward = widget.forward;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _animation);
  }
}
