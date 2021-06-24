part of general_widgets;

class IconTextButton extends StatelessWidget {
  /// Icon to display in button. Leave null to hide icon.
  final IconData? icon;

  /// Image to display between icon and label. Leave null to hide image.
  final Image? image;

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

  /// size of the icon to display in the button
  ///
  /// Defaults to default size defined in [Icon] widget
  final double? iconSize;

  /// Color of the icon to display in the button when active
  ///
  /// Defaults to color defined in [Icon] widget
  final Color? iconColor;

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

  /// The overlay color of the image when no onTap function is provided
  ///
  /// Defaults to greyscale color filter
  final ColorFilter? disabledImageColorFilter;

  /// The color for the button's icon when a pointer is hovering over it.
  ///
  /// Defaults to [ThemeData.hoverColor] of the ambient theme.
  final Color? hoverColor;

  /// The color of the button when in the down (pressed) state.
  ///
  /// Defaults to the Theme's highlight color, [ThemeData.highlightColor].
  final Color? highlightColor;

  /// The radius of the ink Splash
  ///
  /// Defaults to the [InkResponse] radius
  final double? radius;

  const IconTextButton({
    this.icon,
    this.image,
    this.label,
    this.onTap,
    this.toolTip,
    this.mouseCursor = SystemMouseCursors.click,
    this.enableFeedback = true,
    this.iconSize,
    this.iconColor,
    this.labelStyle,
    this.disabledIconColor,
    this.disabledTextColor,
    this.disabledImageColorFilter = const ColorFilter.matrix(<double>[
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),
    this.hoverColor,
    this.highlightColor,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Color? _disabledIconColor;
    Color? _disabledTextColor;
    ColorFilter? _disabledImageColorFilter;

    /// determine disabled status
    if (onTap == null) {
      _disabledIconColor = disabledIconColor ?? theme.disabledColor;
      _disabledTextColor = disabledTextColor ?? theme.disabledColor;
      _disabledImageColorFilter = disabledImageColorFilter;
    }

    /// generate icon
    Widget _icon = Container();
    if (icon != null) {
      _icon = Align(
        alignment: Alignment.topCenter,
        heightFactor: 1.0,
        child: Icon(
          icon!,
          size: iconSize,
          color: _disabledIconColor ?? iconColor,
        ),
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

    /// generate image
    Widget _image = Container();
    if (image != null) {
      _image = image!;
      if (_disabledImageColorFilter != null) {
        // In this case ColorFilter will ignore transparent areas of your images.
        _image = ColorFiltered(
          colorFilter: _disabledImageColorFilter,
          child: image!,
        );
      }
    }

    /// generate button
    Widget toolBarButton = InkResponse(
      onTap: onTap,
      canRequestFocus: onTap != null,
      hoverColor: hoverColor ?? theme.hoverColor,
      highlightColor: highlightColor ?? theme.highlightColor,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      radius: radius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          _icon,
          _image,
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
