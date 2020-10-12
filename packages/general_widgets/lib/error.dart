part of general_widgets;

/// Standardised widget to display errors to the user in a consistent format
class ShowError extends StatelessWidget {
  final String error;
  final String footerText;
  final Function footerTextOnTap;

  ShowError({
    @required this.error,
    this.footerText = 'Go To Login Page',
    this.footerTextOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              SizedBox(height: 10),
              Text(
                'Error: $error',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
                // overflow: TextOverflow.ellipsis,
              ),
              footerText != null ? SizedBox(height: 10) : Container(),
              RichText(
                text: TextSpan(
                  text: footerText ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600],
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (footerTextOnTap != null) {
                        footerTextOnTap();
                      }
                    },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
