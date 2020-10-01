part of multi_auth_ui;

/// Parent sign in page widget to provide user with a list of authentication methods. Google,
/// Facebook, email/password etc.
/// *** NOTE: Colours have been explicity defined in this widget to prevent theming display
/// issues on the user logging in, changing the theme logging out and then viewing the page
/// which has not been designed to supported multiple themes.
class SignInPage extends StatelessWidget {
  final String appIconFilePath;
  final double appIconHeight;
  final double appIconWidth;
  final String appTextFilePath;
  final double appTextHeight;
  final Function() termsOfUseCallback;
  final Function() privacyPolicyCallback;
  final List<String> authProviders;
  final Future Function() signInAnonymously;
  final Future Function() signInWithGoogle;
  final Future Function() signInWithFacebook;
  final Future Function() signInWithApple;
  final Function() emailSignInCallback;
  final String linkCredentialsErrorMessage;
  final Function(dynamic credentials) linkCredentialsCallback;

  const SignInPage({
    Key key,
    @required this.appIconFilePath,
    this.appIconHeight = 50,
    this.appIconWidth = 50,
    @required this.appTextFilePath,
    this.appTextHeight = 12,
    @required this.termsOfUseCallback,
    @required this.privacyPolicyCallback,
    @required this.authProviders,
    this.signInAnonymously,
    this.signInWithGoogle,
    this.signInWithFacebook,
    this.signInWithApple,
    this.emailSignInCallback,
    this.linkCredentialsErrorMessage,
    this.linkCredentialsCallback,
  }) : super(key: key);

  Widget _buildLogo() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          height: appIconHeight,
          width: appIconWidth,
          child: appIconFilePath == null
              ? Text('')
              : Image.asset(
                  appIconFilePath,
                ),
        ),
      ),
    );
  }

  Widget _buildLogoText() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: appTextHeight,
        child: appIconFilePath == null
            ? Text('')
            : Image.asset(
                appTextFilePath,
              ),
      ),
    );
  }

  TextStyle _getFooterTextStyle() {
    return TextStyle(
      color: Colors.grey[600],
    );
  }

  TextStyle _getFooterClickableTextStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
      color: Colors.grey[600],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      height: 75,
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'By signing up, you confirm that you agree to our ',
            style: _getFooterTextStyle(),
            children: <TextSpan>[
              TextSpan(
                text: 'Terms of Use',
                style: _getFooterClickableTextStyle(),
                // https://fluttermaster.com/method-chaining-using-cascade-in-dart/
                // below "chains" the two methods together
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (termsOfUseCallback != null) {
                      termsOfUseCallback();
                    }
                  },
              ),
              TextSpan(
                text: ' and have read and understood our ',
                style: _getFooterTextStyle(),
              ),
              TextSpan(
                text: 'Privacy Policy',
                style: _getFooterClickableTextStyle(),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (privacyPolicyCallback != null) {
                      privacyPolicyCallback();
                    }
                  },
              ),
              TextSpan(
                text: '.',
                style: _getFooterTextStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildLogo(),
            _buildLogoText(),
            AuthOptions(
              authOptionsTitle: 'Log In',
              authProviders: authProviders,
              signInAnonymously: signInAnonymously,
              emailSignInCallback: emailSignInCallback,
              signInWithGoogle: signInWithGoogle,
              signInWithFacebook: signInWithFacebook,
              signInWithApple: signInWithApple,
              linkCredentialsErrorMessage: linkCredentialsErrorMessage,
              linkCredentialsCallback: linkCredentialsCallback,
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }
}
