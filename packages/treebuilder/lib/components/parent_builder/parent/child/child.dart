part of treebuilder;

/// all children widgets to the parent widget are wrapped with this class to
/// enable hiding and showing of child widgets
class ChildWidget extends StatefulWidget {
  final List<Widget> children;
  final bool shouldExpand;

  ChildWidget({
    required this.children,
    this.shouldExpand = false,
  });

  @override
  _ChildWidgetState createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget>
    with SingleTickerProviderStateMixin {
  Animation<double>? sizeAnimation;
  AnimationController? expandController;
  bool? _shouldExpand;

  @override
  void didUpdateWidget(ChildWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runAnimation();
  }

  @override
  void initState() {
    prepareAnimation();
    super.initState();
  }

  @override
  void dispose() {
    expandController!.dispose();
    super.dispose();
  }

  void prepareAnimation() {
    expandController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    Animation<double> curve = CurvedAnimation(
      parent: expandController!,
      curve: Curves.fastOutSlowIn,
    );
    sizeAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  void _runAnimation() {
    /// only run animation if the expanded status has changed
    if (_shouldExpand != widget.shouldExpand) {
      /// run the animation based on the provided expanded status
      if (widget.shouldExpand) {
        expandController!.forward();
      } else {
        expandController!.reverse();
      }
    }
    _shouldExpand = widget.shouldExpand;
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: sizeAnimation!,
      axisAlignment: -1.0,
      child: Column(
        children: widget.children,
      ),
    );
  }
}
