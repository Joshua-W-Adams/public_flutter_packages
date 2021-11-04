part of multi_auth_ui;

class LinkAuthProvidersPage extends StatelessWidget {
  final List<String> authProviders;
  final Future Function()? signInAnonymously;
  final Future Function()? signInWithGoogle;
  final Future Function()? signInWithFacebook;
  final Future Function()? signInWithApple;
  final Function()? emailSignInCallback;

  LinkAuthProvidersPage({
    required this.authProviders,
    this.signInAnonymously,
    this.signInWithGoogle,
    this.signInWithFacebook,
    this.signInWithApple,
    this.emailSignInCallback,
  });

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          text:
              'Account already exists using a different sign in method. Please sign in with one of the existing methods to link them.',
        ),
        textAlign: TextAlign.justify,
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
      appBar: PageAppBar(
        title: 'Link Authentication Credentials',
      ),
      body: _getWebDisplay(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildDescription(context),
            AuthOptions(
              authOptionsTitle: 'Link Credentials',
              authProviders: authProviders,
              // never show separator
              separatorLocation: null,
              signInAnonymously: signInAnonymously,
              signInWithApple: signInWithApple,
              emailSignInCallback: emailSignInCallback,
              signInWithGoogle: signInWithGoogle,
              signInWithFacebook: signInWithFacebook,
            ),
          ],
        ),
      ),
    );
  }
}
