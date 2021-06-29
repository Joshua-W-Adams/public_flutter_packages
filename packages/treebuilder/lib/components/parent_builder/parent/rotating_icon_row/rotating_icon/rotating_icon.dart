part of treebuilder;

class RotatingIcon extends StatelessWidget {
  /// whether the icon should be shown in the expanded or collapsed state
  final bool expanded;

  /// icon to display
  final Icon? icon;

  /// defaults to [kMinInteractiveDimension]
  final double? iconButtonWidth;

  /// defaults to [kMinInteractiveDimension]
  final double? iconButtonHeight;

  /// onPressed callback function for the displayed icon
  final VoidCallback? onPressed;

  const RotatingIcon({
    Key? key,
    required this.expanded,
    this.icon = const Icon(Icons.keyboard_arrow_right),
    this.iconButtonWidth = kMinInteractiveDimension,
    this.iconButtonHeight = kMinInteractiveDimension,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: iconButtonHeight,
      width: iconButtonWidth,
      child: IconButton(
        onPressed: onPressed,
        icon: RotationAnimation(
          forward: expanded,
          child: icon!,
        ),
      ),
    );
  }
}
