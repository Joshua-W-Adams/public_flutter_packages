part of treebuilder;

/// Wrapper widget for all parent widgets to enable disabling or hiding all child
/// widgets
class ParentWidget extends StatefulWidget {
  /// whether the widget should display all children or not
  final bool expanded;

  /// widget to always be displayed regardless of expanded status
  final Widget parent;

  /// children widgets that are conditionally displayed based on the expanded
  /// status
  final List<Widget> children;

  /// icon to display to the left of the parent widget
  final Icon? icon;

  /// Color of the parent widget only. includes the icon row color.
  final Color? parentRowColor;

  /// onPressed callback function for the displayed icon
  final VoidCallback? onPressed;

  ParentWidget({
    Key? key,
    required this.expanded,
    required this.parent,
    required this.children,
    this.icon = const Icon(Icons.keyboard_arrow_down),
    this.parentRowColor,
    this.onPressed,
  }) : super(key: key);

  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget>
    with SingleTickerProviderStateMixin {
  Animation<double>? sizeAnimation;
  AnimationController? expandController;

  @override
  void initState() {
    super.initState();
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
      ..addListener(
        () {
          setState(() {});
        },
      );
  }

  @override
  void dispose() {
    expandController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// run the animation based on the provided expanded status
    if (widget.expanded) {
      expandController!.forward();
    } else {
      expandController!.reverse();
    }

    return Column(
      children: [
        Container(
          color: widget.parentRowColor,
          child: Row(
            children: [
              widget.icon != null
                  ? IconButton(
                      onPressed: widget.onPressed,
                      icon: RotationTransition(
                        turns: sizeAnimation!,
                        child: widget.icon,
                      ),
                    )
                  : Container(),
              // parent widget builder executed here
              widget.parent,
            ],
          ),
        ),
        ChildWidget(
          children: widget.children,
          shouldExpand: widget.expanded,
        ),
      ],
    );
  }
}
