part of general_widgets;

class Awaiting extends StatelessWidget {
  final String? headerText;
  final String? footerText;
  final Function? footerTextOnTap;

  Awaiting({
    this.headerText = 'Loading...',
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
              Padding(
                padding: const EdgeInsets.only(
                  top: 32.0,
                  bottom: 32.0,
                ),
                child: RichText(
                  text: TextSpan(
                    text: headerText ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[600],
                    ),
                  ),
                ),
              ),
              CircularProgressIndicator(),
              // if for some reason the auth service is down and a user object
              // is not returned. Allow user to return to the login page and
              // try again.
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 32.0,
                    bottom: 32.0,
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: footerText ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[600],
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          if (footerTextOnTap != null) {
                            footerTextOnTap!();
                          }
                        },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
