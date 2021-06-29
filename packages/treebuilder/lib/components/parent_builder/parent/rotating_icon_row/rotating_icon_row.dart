part of treebuilder;

class RotatingIconRow extends StatelessWidget {
  /// whether the icon should be shown in the expanded or collapsed state
  final bool expanded;

  /// content of row
  final Widget content;

  /// widget to be placed infront of the content and icon widgets
  final Widget? leading;

  /// widget to be placed behind the cotent and icon widgets
  final Widget? trailing;

  /// icon to display
  final Icon? icon;

  /// defaults to [kMinInteractiveDimension]
  final double? iconButtonWidth;

  /// defaults to [kMinInteractiveDimension]
  final double? iconButtonHeight;

  /// whether to display the icon before or after the cotent widget
  final bool iconLeading;

  /// onPressed callback function for the displayed icon
  final VoidCallback? onPressed;

  /// background color of the row
  final Color? rowColor;

  RotatingIconRow({
    Key? key,
    required this.expanded,
    required this.content,
    this.leading,
    this.trailing,
    this.icon = const Icon(Icons.keyboard_arrow_right),
    this.iconButtonWidth = kMinInteractiveDimension,
    this.iconButtonHeight = kMinInteractiveDimension,
    this.iconLeading = true,
    this.onPressed,
    this.rowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _icon = icon != null
        ? RotatingIcon(
            expanded: expanded,
            icon: icon,
            iconButtonHeight: iconButtonHeight,
            iconButtonWidth: iconButtonWidth,
            onPressed: onPressed,
          )
        : Container();

    List<Widget> rowWidgets = [
      if (leading != null) ...[leading!],
      if (iconLeading == true) ...[_icon],
      content,
      if (iconLeading == false) ...[_icon],
      if (trailing != null) ...[trailing!]
    ];

    return Container(
      color: rowColor,
      child: Row(
        children: rowWidgets,
      ),
    );
  }
}
