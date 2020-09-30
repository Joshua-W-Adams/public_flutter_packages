part of multi_auth_ui;

enum EmailPasswordSignInFormType { signIn, register, forgotPassword }

class EmailPasswordSignInModel with EmailAndPasswordValidators, ChangeNotifier {
  String email;
  String password;
  EmailPasswordSignInFormType formType;
  bool isLoading;
  bool submitted;
  final Future Function(String email, String password)
      signInWithEmailAndPassword;
  final Future Function(String email, String password)
      createUserWithEmailAndPassword;
  final Future Function(String email) sendPasswordResetEmail;

  EmailPasswordSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailPasswordSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
    @required this.signInWithEmailAndPassword,
    @required this.createUserWithEmailAndPassword,
    @required this.sendPasswordResetEmail,
  });

  Future<bool> submit() async {
    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        return false;
      }
      updateWith(isLoading: true);
      switch (formType) {
        case EmailPasswordSignInFormType.signIn:
          await signInWithEmailAndPassword(email, password);
          break;
        case EmailPasswordSignInFormType.register:
          await createUserWithEmailAndPassword(email, password);
          break;
        case EmailPasswordSignInFormType.forgotPassword:
          await sendPasswordResetEmail(email);
          updateWith(isLoading: false);
          break;
      }
      return true;
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) {
    updateWith(email: email);
  }

  void updatePassword(String password) {
    updateWith(password: password);
  }

  void updateFormType(EmailPasswordSignInFormType formType) {
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateWith({
    String email,
    String password,
    EmailPasswordSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  String get passwordLabelText {
    if (formType == EmailPasswordSignInFormType.register) {
      return '8 character minimum';
    }
    return 'Password';
  }

  // Getters
  String get primaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: 'Create',
      EmailPasswordSignInFormType.signIn: 'Sign In',
      EmailPasswordSignInFormType.forgotPassword: 'Send Reset Code',
    }[formType];
  }

  String get secondaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: 'Already have an account?',
      EmailPasswordSignInFormType.signIn: 'Need an account?',
      EmailPasswordSignInFormType.forgotPassword: 'Back to sign in',
    }[formType];
  }

  EmailPasswordSignInFormType get secondaryActionFormType {
    return <EmailPasswordSignInFormType, EmailPasswordSignInFormType>{
      EmailPasswordSignInFormType.register: EmailPasswordSignInFormType.signIn,
      EmailPasswordSignInFormType.signIn: EmailPasswordSignInFormType.register,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInFormType.signIn,
    }[formType];
  }

  String get errorAlertTitle {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: 'Registration failed',
      EmailPasswordSignInFormType.signIn: 'Sign in failed',
      EmailPasswordSignInFormType.forgotPassword: 'Password reset failed',
    }[formType];
  }

  String get title {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: 'Register',
      EmailPasswordSignInFormType.signIn: 'Sign In',
      EmailPasswordSignInFormType.forgotPassword: 'Forgot Password',
    }[formType];
  }

  bool get canSubmitEmail {
    return emailSubmitValidator.isValid(email);
  }

  bool get canSubmitPassword {
    if (formType == EmailPasswordSignInFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  bool get canSubmit {
    final bool canSubmitFields =
        formType == EmailPasswordSignInFormType.forgotPassword
            ? canSubmitEmail
            : canSubmitEmail && canSubmitPassword;
    return canSubmitFields && !isLoading;
  }

  String get emailErrorText {
    final bool showErrorText = submitted && !canSubmitEmail;
    final String errorText =
        email.isEmpty ? 'Email Empty' : 'Incorrect Email Format';
    return showErrorText ? errorText : null;
  }

  String get passwordErrorText {
    final bool showErrorText = submitted && !canSubmitPassword;
    final String errorText =
        password.isEmpty ? 'Password Empty' : 'Password Too Short';
    return showErrorText ? errorText : null;
  }

  @override
  String toString() {
    return 'email: $email, password: $password, formType: $formType, isLoading: $isLoading, submitted: $submitted';
  }
}
