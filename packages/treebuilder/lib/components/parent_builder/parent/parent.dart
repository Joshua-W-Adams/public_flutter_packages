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

  /// widget to be placed infront of the parent and icon widgets
  final Widget? leading;

  /// widget to be placed behind the parent and icon widgets
  final Widget? trailing;

  /// icon to display to the left of the parent widget
  final Icon? icon;

  /// defaults to [kMinInteractiveDimension]
  final double? iconButtonWidth;

  /// defaults to [kMinInteractiveDimension]
  final double? iconButtonHeight;

  /// whether to display the icon before or after the parent widget
  final bool iconLeading;

  /// Color of the parent widget only. includes the icon row color.
  final Color? parentRowColor;

  /// onPressed callback function for the displayed icon
  final VoidCallback? onPressed;

  /// display children above the parent widget. Default is to display below the
  /// parent widget.
  final bool expandUp;

  ParentWidget({
    Key? key,
    required this.expanded,
    required this.parent,
    required this.children,
    this.leading,
    this.trailing,
    this.icon = const Icon(Icons.keyboard_arrow_right),
    this.iconButtonWidth = kMinInteractiveDimension,
    this.iconButtonHeight = kMinInteractiveDimension,
    this.iconLeading = true,
    this.parentRowColor,
    this.onPressed,
    this.expandUp = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _icon = icon != null
        ? SizedBox(
            height: iconButtonHeight,
            width: iconButtonWidth,
            child: IconButton(
              onPressed: onPressed,
              icon: RotationAnimation(
                forward: expanded,
                child: icon!,
              ),
            ),
          )
        : Container();

    List<Widget> parentWidgets = [
      if (leading != null) ...[leading!],
      if (iconLeading == true) ...[_icon],
      parent,
      if (iconLeading == false) ...[_icon],
      if (trailing != null) ...[trailing!]
    ];

    Widget _children = ChildWidget(
      children: children,
      shouldExpand: expanded,
    );

    return Column(
      children: [
        if (expandUp) ...[_children],
        Container(
          color: parentRowColor,
          child: Row(
            children: parentWidgets,
          ),
        ),
        if (!expandUp) ...[_children],
      ],
    );
  }
}
