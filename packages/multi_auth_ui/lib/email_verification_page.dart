part of multi_auth_ui;

class EmailVerificationPage extends StatefulWidget {
  final Function signOut;
  final Future Function() sendVerificationEmail;

  EmailVerificationPage({
    Key? key,
    required this.signOut,
    required this.sendVerificationEmail,
  }) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _emailRequestPending = false;
  String? _serverResponse = '';

  Map<String, String> _errors = {
    'ERROR_TOO_MANY_REQUESTS': 'Too many requests. Please try again later.'
  };

  void sendVerificationEmail() {
    // if no verification email is currently being sent
    if (_emailRequestPending == false) {
      // set loading status to true to prevent multiple email verification requests
      _emailRequestPending = true;
      // rebuild state to display to user
      setState(() {});
      // send verification email from firebase.
      widget.sendVerificationEmail().then((_) {
        // email sucessfully sent
        _emailRequestPending = false;
        _serverResponse = 'Verification email sucessfully sent.';
        setState(() {});
      }).catchError((e) {
        // error encountered in email verification process
        _emailRequestPending = false;
        // return custom error message or message from firebase server
        _serverResponse = _errors[e.code] ?? e.message;
        setState(() {});
      });
    }
    // pending result of verification email. Do nothing.
  }

  Widget _buildCheckVerificationStatus() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Checking Verification Status...'),
          SizedBox(height: 32),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          text:
              'Please check your inbox to verify your email. If you have not recieved a verification email please press the button below to resend the email.',
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildSendEmailButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: StackButton(
          text: 'Resend Email',
          child: Icon(
            Icons.email,
          ),
          disabledColor: Theme.of(context).canvasColor,
          onPressed: _emailRequestPending ? null : sendVerificationEmail,
        ),
      ),
    );
  }

  Widget _buildServerMessage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(_serverResponse!),
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
        title: 'Email Verification',
        backButtonOnPressed: () {
          widget.signOut();
        },
      ),
      body: _getWebDisplay(
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildDescription(),
            _buildCheckVerificationStatus(),
            _buildServerMessage(),
            _buildSendEmailButton(),
          ],
        ),
      ),
    );
  }
}
