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
    return SizedBox(
      width: 28,
      height: 28,
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor =
        Theme.of(context).textTheme.bodyText1.color.withOpacity(0.5);
    return SizedBox(
      height: height,
      child: ElevatedButton(
        child: loading ? buildSpinner(context) : child,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              ),
              side: BorderSide(
                color: borderColor,
              ),
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return color;
              else if (states.contains(MaterialState.disabled))
                return disabledColor;
              return null; // Use the component's default.
            },
          ),
          elevation: MaterialStateProperty.all(0),
          textStyle: MaterialStateProperty.all(
            TextStyle(
              color: textColor,
            ),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
