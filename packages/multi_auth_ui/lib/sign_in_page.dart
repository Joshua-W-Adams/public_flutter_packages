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
  final Function() billingTermsCallback;
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
    @required this.billingTermsCallback,
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
        child: appTextFilePath == null
            ? Text('')
            : Image.asset(
                appTextFilePath,
              ),
      ),
    );
  }

  Widget _getWebDisplay(Widget child) {
    if (kIsWeb) {
      return Center(
        child: AspectRatio(
          aspectRatio: 9.0 / 16.0,
          child: child,
        ),
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getWebDisplay(
        Container(
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
              TermsAndConditions(
                termsOfUseCallback: termsOfUseCallback,
                billingTermsCallback: billingTermsCallback,
                privacyPolicyCallback: privacyPolicyCallback,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
