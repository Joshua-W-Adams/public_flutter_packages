part of general_widgets;

class IconTextButton extends StatefulWidget {
  /// Icon to display in button. Leave null to hide icon.
  final IconData? icon;

  /// Image to display between icon and label. Leave null to hide image.
  final Image? image;

  /// Text to display under icon. Leave null to hide text.
  final String? label;

  /// function to execute when user taps button. Leave null to disable button.
  ///
  /// a loading indicator will be displayed while the async function is
  /// processing
  final AsyncCallback? onTap;

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

  /// widget to display while the onTap [AsyncCallback] is processing
  ///
  /// Defaults to a [CircularProgressIndicator]
  final Widget loadingIndicator;

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
    this.loadingIndicator = const Padding(
      padding: const EdgeInsets.all(4.0),
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
      ),
    ),
  });

  @override
  _IconTextButtonState createState() => _IconTextButtonState();
}

class _IconTextButtonState extends State<IconTextButton> {
  bool _asyncInProgress = false;

  void _setState() {
    if (mounted) {
      /// mounted check to confirm widget has not been removed from tree while
      /// async function is still in progress
      setState(() {});
    }
  }

  void _onTap() async {
    if (_asyncInProgress != true && widget.onTap != null) {
      _asyncInProgress = true;
      _setState();
      await widget.onTap?.call().then((_) {
        _asyncInProgress = false;
        _setState();
      }).onError((error, stackTrace) {
        _asyncInProgress = false;
        _setState();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Color? _disabledIconColor;
    Color? _disabledTextColor;
    ColorFilter? _disabledImageColorFilter;

    /// determine disabled status
    if (widget.onTap == null) {
      _disabledIconColor = widget.disabledIconColor ?? theme.disabledColor;
      _disabledTextColor = widget.disabledTextColor ?? theme.disabledColor;
      _disabledImageColorFilter = widget.disabledImageColorFilter;
    }

    double _iconSize = widget.iconSize ?? theme.iconTheme.size ?? 24.0;

    /// generate icon
    Widget _icon = Container();
    if (widget.icon != null) {
      _icon = Align(
        alignment: Alignment.topCenter,
        heightFactor: 1.0,
        child: Icon(
          widget.icon!,
          size: _iconSize,
          color: _disabledIconColor ?? widget.iconColor,
        ),
      );
    }

    /// generate icon label
    Widget _label = Container();
    if (widget.label != null) {
      TextStyle _labelStyle = widget.labelStyle ?? TextStyle();
      if (_disabledTextColor != null) {
        _labelStyle = _labelStyle.copyWith(color: _disabledTextColor);
      }
      _label = Text(
        widget.label!,
        style: _labelStyle,
      );
    }

    /// generate image
    Widget _image = Container();
    if (widget.image != null) {
      _image = widget.image!;
      if (_disabledImageColorFilter != null) {
        // In this case ColorFilter will ignore transparent areas of your images.
        _image = ColorFiltered(
          colorFilter: _disabledImageColorFilter,
          child: widget.image!,
        );
      }
    }

    /// generate loading indicator
    Widget _loadingIndicator = SizedBox(
      height: _iconSize,
      width: _iconSize,
      child: widget.loadingIndicator,
    );

    /// generate button
    Widget toolBarButton = InkResponse(
      onTap: _asyncInProgress == false && widget.onTap != null ? _onTap : null,
      canRequestFocus: widget.onTap != null,
      hoverColor: widget.hoverColor ?? theme.hoverColor,
      highlightColor: widget.highlightColor ?? theme.highlightColor,
      mouseCursor: widget.mouseCursor,
      enableFeedback: widget.enableFeedback,
      radius: widget.radius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_asyncInProgress) _icon,
          if (!_asyncInProgress) _image,
          if (_asyncInProgress) _loadingIndicator,
          _label,
        ],
      ),
    );

    /// conditionally wrap with tooltip
    if (widget.toolTip != null) {
      toolBarButton = Tooltip(
        message: widget.toolTip!,
        preferBelow: false,
        child: toolBarButton,
      );
    }

    return toolBarButton;
  }
}
