part of multi_auth_ui;

/// Widget to generate a list of authentication options for a user with sign on
/// with. Links sign in credentials if applicable.
class AuthOptions extends StatefulWidget {
  final String authOptionsTitle;
  final List<String> authProviders;
  final Future Function() signInAnonymously;
  final Future Function() signInWithGoogle;
  final Future Function() signInWithFacebook;
  final Future Function() signInWithApple;
  final String linkCredentialsErrorMessage;
  final Function(dynamic credentials) linkCredentialsCallback;
  final Function() emailSignInCallback;
  final int separatorLocation;

  AuthOptions({
    Key key,
    @required this.authOptionsTitle,
    this.authProviders = const [
      "password",
      "google.com",
      "facebook.com",
      "apple.com",
      "anonymous"
    ],
    this.signInAnonymously,
    this.signInWithGoogle,
    this.signInWithFacebook,
    this.signInWithApple,
    this.linkCredentialsErrorMessage =
        "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL",
    this.linkCredentialsCallback,
    this.emailSignInCallback,
    this.separatorLocation = 1,
  }) : super(key: key);

  @override
  _AuthOptionsState createState() => _AuthOptionsState();
}

class _AuthOptionsState extends State<AuthOptions> {
  bool _isLoading = false;

  /// Generic sign in method to notifiy any listing widgets or consumers
  /// 1. Prevent multiple sign in requests by disabling buttons
  /// 2. Display loading notifications as applicable
  Future<void> _signIn(Future<void> Function() signInMethod) async {
    try {
      _isLoading = true;
      setState(() {});
      return await signInMethod();
    } catch (e) {
      _isLoading = false;
      setState(() {});
      // redirect user to the account credential linking process.
      if (e is PlatformException &&
          e.code == widget.linkCredentialsErrorMessage) {
        if (widget.linkCredentialsCallback != null) {
          widget.linkCredentialsCallback(e.details);
        }
      } else {
        await showExceptionAlertDialog(
          context: context,
          title: 'Sign in Failed',
          exception: e,
        );
      }
    }
  }

  Widget _buildToggleTitle() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Center(
      child: Text(
        this.widget.authOptionsTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  void _showNoSignInFunctionError() {
    showAlertDialog(
      context: context,
      title: 'Error',
      content: 'No sign in function provided ',
      defaultActionText: 'Close',
    );
  }

  Widget _buildEmailSignInButton() {
    return StackButton(
      text: 'Email',
      child: Icon(
        Icons.person,
      ),
      disabledColor: Colors.grey[100],
      // Assigning a null value to the onpressed event disables the button
      onPressed: _isLoading
          ? null
          : () {
              if (widget.emailSignInCallback != null) {
                widget.emailSignInCallback();
              } else {
                _showNoSignInFunctionError();
              }
            },
    );
  }

  Widget _buildGoogleSignInButton() {
    return StackButton(
      text: 'Google',
      child: Container(
        height: 25.0,
        width: 25.0,
        child:
            Image.asset('assets/img/google_icon.png', package: 'multi_auth_ui'),
      ),
      disabledColor: Colors.grey[100],
      onPressed: _isLoading
          ? null
          : () async {
              if (widget.signInWithGoogle != null) {
                await _signIn(() {
                  return widget.signInWithGoogle();
                });
              } else {
                _showNoSignInFunctionError();
              }
            },
    );
  }

  Widget _buildAppleSignInButton() {
    return StackButton(
      text: 'Apple',
      child: Container(
        height: 25.0,
        width: 25.0,
        child:
            Image.asset('assets/img/apple_icon.png', package: 'multi_auth_ui'),
      ),
      disabledColor: Colors.grey[100],
      onPressed: _isLoading
          ? null
          : () async {
              if (widget.signInWithApple != null) {
                await _signIn(() {
                  return widget.signInWithApple();
                });
              } else {
                _showNoSignInFunctionError();
              }
            },
    );
  }

  Widget _buildFacebookSignInButton() {
    return StackButton(
      text: 'Facebook',
      child: Container(
        height: 25.0,
        width: 25.0,
        child: Image.asset('assets/img/facebook_icon.png',
            package: 'multi_auth_ui'),
      ),
      disabledColor: Colors.grey[100],
      onPressed: _isLoading
          ? null
          : () async {
              if (widget.signInWithFacebook != null) {
                await _signIn(() {
                  return widget.signInWithFacebook();
                });
              } else {
                _showNoSignInFunctionError();
              }
            },
    );
  }

  Widget _buildAnonymousSignInButton() {
    return StackButton(
      text: 'Anonymous',
      child: Icon(
        Icons.alternate_email,
      ),
      disabledColor: Colors.grey[100],
      onPressed: _isLoading
          ? null
          : () async {
              if (widget.signInAnonymously != null) {
                await _signIn(() {
                  return widget.signInAnonymously();
                });
              } else {
                _showNoSignInFunctionError();
              }
            },
    );
  }

  Widget _buildSeparator() {
    return Container(
      width: 275,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 50,
            child: Text(
              'Or',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _showAvailableSignInOptions() {
    List<Widget> signInOptions = <Widget>[];
    // loop through available providers
    for (var i = 0; i < widget.authProviders.length; i++) {
      String provider = widget.authProviders[i];
      if (i == 0) {
        // append title widget
        signInOptions.addAll([
          SizedBox(
            height: 50.0,
            child: _buildToggleTitle(),
          ),
        ]);
      }
      // add separator if applicable
      if (widget.separatorLocation == i) {
        signInOptions.addAll([
          SizedBox(height: 16),
          _buildSeparator(),
        ]);
      }
      // case 1 - google provider available
      if (provider == "google.com") {
        signInOptions.addAll([
          SizedBox(height: 16.0),
          _buildGoogleSignInButton(),
        ]);
        // case 2 - facebook provider available
      } else if (provider == "facebook.com") {
        signInOptions.addAll([
          SizedBox(height: 16.0),
          _buildFacebookSignInButton(),
        ]);
      } else if (provider == "apple.com") {
        // case 3 - apple provider available
        signInOptions.addAll([
          SizedBox(height: 16.0),
          _buildAppleSignInButton(),
        ]);
      } else if (provider == "password") {
        // case 4 - email / password provider available
        signInOptions.addAll([
          SizedBox(height: 16.0),
          _buildEmailSignInButton(),
        ]);
      } else if (provider == "anonymous") {
        // case 5 - anonymous provider available
        signInOptions.addAll([
          SizedBox(height: 16.0),
          _buildAnonymousSignInButton(),
        ]);
      }
    }
    // case 4 - no providers available for account
    if (widget.authProviders.length == null) {
      signInOptions = [
        Text('Error. No sign in options available for existing user.'),
      ];
    }
    return signInOptions;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: _showAvailableSignInOptions(),
            ),
          ),
        ),
      ),
    );
  }
}
