part of treebuilder;

/// Wrapper widget for all parent widgets to enable disabling or hiding all child
/// widgets
class ParentWidget extends StatelessWidget {
  /// whether the widget should display all children or not
  final bool expanded;

  /// widget to always be displayed regardless of expanded status
  final Widget parent;

  /// children widgets that are conditionally displayed based on the expanded
  /// status
  final List<Widget> children;

  /// display children above the parent widget. Default is to display below the
  /// parent widget.
  final bool expandUp;

  ParentWidget({
    Key? key,
    required this.expanded,
    required this.parent,
    required this.children,
    this.expandUp = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _children = ChildWidget(
      children: children,
      shouldExpand: expanded,
    );

    return Column(
      children: [
        if (expandUp) ...[_children],
        parent,
        if (!expandUp) ...[_children],
      ],
    );
  }
}
