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

  /// widget to be placed infront of the parent and icon widgets
  final Widget? leading;

  /// widget to be placed behind the parent and icon widgets
  final Widget? trailing;

  /// icon to display to the left of the parent widget
  final Icon? icon;

  /// whether to display the icon before or after the parent widget
  final bool iconLeading;

  /// Color of the parent widget only. includes the icon row color.
  final Color? parentRowColor;

  /// onPressed callback function for the displayed icon
  final VoidCallback? onPressed;

  ParentWidget({
    Key? key,
    required this.expanded,
    required this.parent,
    required this.children,
    this.leading,
    this.trailing,
    this.icon = const Icon(Icons.keyboard_arrow_down),
    this.iconLeading = true,
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
  bool? _expanded;

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

  void _runAnimation() {
    /// only run animation if the expanded status has changed
    if (_expanded != widget.expanded) {
      /// run the animation based on the provided expanded status
      if (widget.expanded) {
        expandController!.forward();
      } else {
        expandController!.reverse();
      }
      _expanded = widget.expanded;
    }
  }

  @override
  Widget build(BuildContext context) {
    _runAnimation();
    Widget icon = widget.icon != null
        ? IconButton(
            onPressed: widget.onPressed,
            icon: RotationTransition(
              turns: sizeAnimation!,
              child: widget.icon,
            ),
          )
        : Container();

    List<Widget> parentWidgets = [
      if (widget.leading != null) ...[widget.leading!],
      if (widget.iconLeading == true) ...[icon],
      widget.parent,
      if (widget.iconLeading == false) ...[icon],
      if (widget.trailing != null) ...[widget.trailing!]
    ];

    return Column(
      children: [
        Container(
          color: widget.parentRowColor,
          child: Row(
            children: parentWidgets,
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
