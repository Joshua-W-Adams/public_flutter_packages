part of general_widgets;

class IconTextButton extends StatelessWidget {
  /// Icon to display in button. Leave null to hide icon.
  final Icon? icon;

  /// Text to display under icon. Leave null to hide text.
  final String? label;

  /// function to execute when user taps button. Leave null to disable button.
  final VoidCallback? onTap;

  /// optional tooltip to display.
  final String? toolTip;

  /// cursor to display when user mouses over button
  ///
  /// Defaults to [SystemMouseCursors.click]
  final MouseCursor mouseCursor;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  final bool enableFeedback;

  /// text style to apply to label
  final TextStyle? labelStyle;

  /// The color of the icon when no onTap function is provided
  ///
  /// Defaults to [ThemeData.disabledColor]
  final Color? disabledIconColor;

  /// The color of the label text when no onTap function is provided
  ///
  /// Defaults to [ThemeData.disabledColor]
  final Color? disabledTextColor;

  /// The color for the button's icon when a pointer is hovering over it.
  ///
  /// Defaults to [ThemeData.hoverColor] of the ambient theme.
  final Color? hoverColor;

  /// The color of the button when in the down (pressed) state.
  ///
  /// Defaults to the Theme's highlight color, [ThemeData.highlightColor].
  final Color? highlightColor;

  const IconTextButton({
    this.icon,
    this.label,
    this.onTap,
    this.toolTip,
    this.mouseCursor = SystemMouseCursors.click,
    this.enableFeedback = true,
    this.labelStyle,
    this.disabledIconColor,
    this.disabledTextColor,
    this.hoverColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Color? _disabledIconColor;
    Color? _disabledTextColor;

    /// determine disabled status
    if (onTap == null) {
      _disabledIconColor = disabledIconColor ?? theme.disabledColor;
      _disabledTextColor = disabledTextColor ?? theme.disabledColor;
    }

    /// generate icon
    Widget _icon = Container();
    if (icon != null) {
      Widget _iconChild = icon!;
      if (_disabledIconColor != null) {
        _iconChild = IconTheme.merge(
          data: IconThemeData(
            color: _disabledIconColor,
          ),
          child: icon!,
        );
      }
      _icon = Align(
        alignment: Alignment.topCenter,
        heightFactor: 1.0,
        child: _iconChild,
      );
    }

    /// generate icon label
    Widget _label = Container();
    if (label != null) {
      TextStyle _labelStyle = labelStyle ?? TextStyle();
      if (_disabledTextColor != null) {
        _labelStyle = _labelStyle.copyWith(color: _disabledTextColor);
      }
      _label = Text(
        label!,
        style: _labelStyle,
      );
    }

    /// generate button
    Widget toolBarButton = InkResponse(
      onTap: onTap,
      canRequestFocus: onTap != null,
      hoverColor: hoverColor ?? theme.hoverColor,
      highlightColor: highlightColor ?? theme.highlightColor,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          _icon,
          _label,
        ],
      ),
    );

    /// conditionally wrap with tooltip
    if (toolTip != null) {
      toolBarButton = Tooltip(
        message: toolTip!,
        preferBelow: false,
        child: toolBarButton,
      );
    }

    return toolBarButton;
  }
}
