part of treebuilder;

/// Wrapper widget for all parent widgets to enable disabling or hiding all child
/// widgets
class ParentWidget extends StatefulWidget {
  final Widget parent;
  final List<Widget> children;
  final IconData arrowIcon;
  // final bool shouldExpand;
  // final Function onToggle;

  /// style configuration properties
  final Color? parentRowColor;

  ParentWidget({
    Key? key,
    required this.parent,
    required this.children,
    this.arrowIcon = Icons.keyboard_arrow_down,
    // this.shouldExpand = false,
    // this.onToggle,
    this.parentRowColor,
  }) : super(key: key);

  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget>
    with SingleTickerProviderStateMixin {
  bool shouldExpand = false;
  Animation<double>? sizeAnimation;
  AnimationController? expandController;

  @override
  void initState() {
    super.initState();
    // shouldExpand = widget.shouldExpand;
    // print(shouldExpand);
    prepareAnimation();
  }

  // @override
  // void didUpdateWidget(ParentWidget oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // update detected, rebuild widget state
  //   setState(() {});
  // }

  @override
  void dispose() {
    super.dispose();
    expandController!.dispose();
  }

  void prepareAnimation() {
    expandController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    Animation<double> curve = CurvedAnimation(
      parent: expandController!,
      curve: Curves.fastOutSlowIn,
    );
    sizeAnimation = Tween(
      begin: 0.0,
      end: 0.5,
    ).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: widget.parentRowColor,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  // if (widget.onToggle != null) {
                  //   widget.onToggle();
                  // }
                  setState(() {
                    shouldExpand = !shouldExpand;
                  });
                  if (shouldExpand) {
                    expandController!.forward();
                  } else {
                    expandController!.reverse();
                  }
                },
                icon: RotationTransition(
                  turns: sizeAnimation!,
                  child: Icon(
                    widget.arrowIcon,
                  ),
                ),
              ),
              // parent widget builder executed here
              widget.parent,
            ],
          ),
        ),
        ChildWidget(
          children: widget.children,
          shouldExpand: shouldExpand,
        )
      ],
    );
  }
}
