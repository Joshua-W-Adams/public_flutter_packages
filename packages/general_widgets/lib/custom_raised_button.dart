part of general_widgets;

@immutable
class CustomRaisedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color disabledColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final bool loading;
  final VoidCallback onPressed;

  const CustomRaisedButton({
    Key key,
    @required this.child,
    this.color,
    this.disabledColor,
    this.textColor,
    this.height = 50.0,
    this.borderRadius = 4.0,
    this.loading = false,
    this.onPressed,
  }) : super(key: key);

  Widget buildSpinner(BuildContext context) {
    final ThemeData data = Theme.of(context);
    return Theme(
      data: data.copyWith(accentColor: Colors.white70),
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: loading ? buildSpinner(context) : child,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          side: BorderSide(
            color: Colors.grey[300],
          ),
        ),
        color: color ?? Colors.transparent,
        elevation: 0,
        disabledColor: disabledColor,
        textColor: textColor,
        onPressed: onPressed,
      ),
    );
  }
}
