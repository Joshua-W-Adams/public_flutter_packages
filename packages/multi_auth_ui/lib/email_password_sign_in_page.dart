part of multi_auth_ui;

class EmailPasswordSignInPageBuilder extends StatelessWidget {
  final VoidCallback onSignedIn;
  final EmailPasswordSignInModel model;
  final String initialEmail;
  final String initialPassword;

  const EmailPasswordSignInPageBuilder({
    Key key,
    this.onSignedIn,
    @required this.model,
    this.initialEmail,
    this.initialPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EmailPasswordSignInModel>(
      create: (_) {
        return model;
      },
      child: Consumer<EmailPasswordSignInModel>(
        builder: (_, model, __) {
          return EmailPasswordSignInPage(
            model: model,
            onSignedIn: onSignedIn,
            initialEmail: initialEmail,
            initialPassword: initialPassword,
          );
        },
      ),
    );
  }
}

class EmailPasswordSignInPage extends StatefulWidget {
  final EmailPasswordSignInModel model;
  final VoidCallback onSignedIn;
  final String initialEmail;
  final String initialPassword;

  const EmailPasswordSignInPage({
    Key key,
    @required this.model,
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

  EmailPasswordSignInModel get model {
    return widget.model;
  }

  @override
  void initState() {
    // set default values of email and password if provided
    if (widget.initialEmail != null) {
      _emailController.text = widget.initialEmail;
      widget.model.email = widget.initialEmail;
    }
    if (widget.initialPassword != null) {
      _passwordController.text = widget.initialPassword;
      widget.model.password = widget.initialPassword;
    }
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSignInError(EmailPasswordSignInModel model, dynamic exception) {
    showExceptionAlertDialog(
      context: context,
      title: model.errorAlertTitle,
      exception: exception,
    );
  }

  Future<void> _submit() async {
    try {
      final bool success = await model.submit();
      if (success) {
        if (model.formType == EmailPasswordSignInFormType.forgotPassword) {
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
      _showSignInError(model, e);
    }
  }

  void _updateFormType(EmailPasswordSignInFormType formType) {
    model.updateFormType(formType);
    _emailController.clear();
    _passwordController.clear();
  }

  Widget _buildEmailField() {
    return TextField(
      key: Key('email'),
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
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
      onChanged: model.updateEmail,
      inputFormatters: <TextInputFormatter>[
        model.emailInputFormatter,
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      key: Key('password'),
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: model.passwordLabelText,
        errorText: model.passwordErrorText,
        enabled: !model.isLoading,
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
      onChanged: model.updatePassword,
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 16.0),
        _buildEmailField(),
        if (model.formType !=
            EmailPasswordSignInFormType.forgotPassword) ...<Widget>[
          SizedBox(height: 16.0),
          _buildPasswordField(),
        ],
        SizedBox(height: 16.0),
        CustomRaisedButton(
          key: Key('primary-button'),
          child: Text(model.primaryButtonText),
          loading: model.isLoading,
          onPressed: model.isLoading ? null : _submit,
          disabledColor: Theme.of(context).canvasColor,
          color: Theme.of(context).primaryColor,
          textColor: Theme.of(context).primaryTextTheme.bodyText1.color,
        ),
        SizedBox(height: 16.0),
        FlatButton(
          key: Key('secondary-button'),
          child: Text(model.secondaryButtonText),
          onPressed: model.isLoading
              ? null
              : () {
                  return _updateFormType(model.secondaryActionFormType);
                },
        ),
        if (model.formType == EmailPasswordSignInFormType.signIn)
          FlatButton(
            key: Key('tertiary-button'),
            child: Text('Forgot your password?'),
            onPressed: model.isLoading
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
        title: model.title,
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
