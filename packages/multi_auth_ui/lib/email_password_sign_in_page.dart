part of multi_auth_ui;

class EmailPasswordSignInPageBuilder extends StatelessWidget {
  final VoidCallback onSignedIn;
  final EmailPasswordSignInBloc bloc;
  final String initialEmail;
  final String initialPassword;

  const EmailPasswordSignInPageBuilder({
    Key key,
    this.onSignedIn,
    @required this.bloc,
    this.initialEmail,
    this.initialPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// [UiStreamBuilder] handles all generic stream errors
    return UiStreamBuilder(
      stream: bloc.stream,
      builder: (_, snapshot) {
        return EmailPasswordSignInPage(
          bloc: snapshot.data,
          onSignedIn: onSignedIn,
          initialEmail: initialEmail,
          initialPassword: initialPassword,
        );
      },
    );
  }
}

class EmailPasswordSignInPage extends StatefulWidget {
  final EmailPasswordSignInBloc bloc;
  final VoidCallback onSignedIn;
  final String initialEmail;
  final String initialPassword;

  const EmailPasswordSignInPage({
    Key key,
    @required this.bloc,
    this.onSignedIn,
    this.initialEmail,
    this.initialPassword,
  }) : super(key: key);

  @override
  _EmailPasswordSignInPageState createState() =>
      _EmailPasswordSignInPageState();
}

class _EmailPasswordSignInPageState extends State<EmailPasswordSignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  EmailPasswordSignInBloc get bloc {
    return widget.bloc;
  }

  @override
  void initState() {
    // set default values of email and password if provided
    if (widget.initialEmail != null) {
      _emailController.text = widget.initialEmail;
      widget.bloc.email = widget.initialEmail;
    }
    if (widget.initialPassword != null) {
      _passwordController.text = widget.initialPassword;
      widget.bloc.password = widget.initialPassword;
    }
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSignInError(EmailPasswordSignInBloc bloc, dynamic exception) {
    showExceptionAlertDialog(
      context: context,
      title: bloc.errorAlertTitle,
      exception: exception,
    );
  }

  Future<void> _submit() async {
    try {
      final bool success = await bloc.submit();
      if (success) {
        if (bloc.formType == EmailPasswordSignInFormType.forgotPassword) {
          await showAlertDialog(
            context: context,
            title: 'Reset Link Sent',
            content:
                'Please check your emails for password reset instructions.',
            defaultActionText: 'ok',
          );
        } else {
          if (widget.onSignedIn != null) {
            widget.onSignedIn();
          }
        }
      }
    } catch (e) {
      _showSignInError(bloc, e);
    }
  }

  void _updateFormType(EmailPasswordSignInFormType formType) {
    bloc.updateFormType(formType);
    _emailController.clear();
    _passwordController.clear();
  }

  Widget _buildEmailField() {
    return TextField(
      key: Key('email'),
      autofillHints: [AutofillHints.username],
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: bloc.emailErrorText,
        // enabled: !bloc.isLoading,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.4),
            width: 2.0,
          ),
        ),
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      keyboardAppearance: Brightness.light,
      onChanged: bloc.updateEmail,
      inputFormatters: <TextInputFormatter>[
        bloc.emailInputFormatter,
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      key: Key('password'),
      autofillHints: [AutofillHints.password],
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: bloc.passwordLabelText,
        errorText: bloc.passwordErrorText,
        // enabled: !bloc.isLoading,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.4),
            width: 2.0,
          ),
        ),
      ),
      obscureText: true,
      autocorrect: false,
      keyboardAppearance: Brightness.light,
      onChanged: bloc.updatePassword,
    );
  }

  void _clearFocus() {
    // create a temp focus node to set focus to
    FocusNode _dummy = FocusNode();
    // assign this focus node
    FocusScope.of(context).requestFocus(_dummy);
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 16.0),

        /// https://github.com/flutter/flutter/pull/52126
        AutofillGroup(
          child: Column(
            children: [
              _buildEmailField(),
              if (bloc.formType !=
                  EmailPasswordSignInFormType.forgotPassword) ...<Widget>[
                SizedBox(height: 16.0),
                _buildPasswordField(),
              ],
            ],
          ),
        ),
        SizedBox(height: 16.0),
        CustomRaisedButton(
          key: Key('primary-button'),
          child: Text(bloc.primaryButtonText),
          loading: bloc.isLoading,
          onPressed: bloc.isLoading
              ? null
              : () {
                  _clearFocus();
                  _submit();
                },
          disabledColor: Theme.of(context).canvasColor,
          color: Theme.of(context).primaryColor,
          textColor: Theme.of(context).primaryTextTheme.bodyText1.color,
        ),
        SizedBox(height: 16.0),
        FlatButton(
          key: Key('secondary-button'),
          child: Text(bloc.secondaryButtonText),
          onPressed: bloc.isLoading
              ? null
              : () {
                  return _updateFormType(bloc.secondaryActionFormType);
                },
        ),
        if (bloc.formType == EmailPasswordSignInFormType.signIn)
          FlatButton(
            key: Key('tertiary-button'),
            child: Text('Forgot your password?'),
            onPressed: bloc.isLoading
                ? null
                : () {
                    return _updateFormType(
                        EmailPasswordSignInFormType.forgotPassword);
                  },
          ),
      ],
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
        title: bloc.title,
      ),
      body: _getWebDisplay(
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }
}
