part of auth_service;

class FirebaseEmailVerificationService {
  final bool emailVerificationCheckRequired;
  User firebaseUser;
  bool _isEmailVerified;
  Timer _timer;
  Timer _timeout;

  final StreamController<bool> _emailVerificationStream =
      StreamController<bool>();

  FirebaseEmailVerificationService({
    @required this.firebaseUser,
    @required this.emailVerificationCheckRequired,
  }) {
    if (emailVerificationCheckRequired == true) {
      // initialise timer to check for verification status every 5 seconds
      _checkForEmailVerificationStatus();
    }
  }

  Stream<bool> get onVerificationStateChange {
    // return the stream of booleans
    return _emailVerificationStream.stream;
  }

  void _add() {
    _emailVerificationStream.add(_isEmailVerified);
  }

  void refreshFirebaseUserData() async {
    // reload current user data
    await firebaseUser
      ..reload();
    // save firebase users data to object parameter
    this.firebaseUser = await FirebaseAuth.instance.currentUser;
  }

  void _checkForEmailVerificationStatus() {
    _timer = Timer.periodic(
      Duration(seconds: 2),
      (timer) async {
        // reload current user data
        refreshFirebaseUserData();
        // if user email is verified cancel timer
        if (firebaseUser.emailVerified) {
          _isEmailVerified = firebaseUser.emailVerified;
          timer.cancel();
          // add email verificaiton status to stream
          _add();
          dispose();
        }
      },
    );
    _timeout = Timer.periodic(Duration(minutes: 10), (timer) {
      // cancel all timers if user has been afk for 10 minutes or longer
      _timer.cancel();
      _timeout.cancel();
    });
  }

  Future<void> sendVerificationEmail() async {
    // restart timers if timed out
    if (_timer == null && _timeout == null) {
      _checkForEmailVerificationStatus();
    }
    // send verification email from firebase.
    await firebaseUser.sendEmailVerification();
  }

  // need to kill the stream when no longer required to prevent memory leaks
  void dispose() {
    _emailVerificationStream.close();
    if (_timer != null) {
      _timer.cancel();
    }
    if (_timeout != null) {
      _timeout.cancel();
    }
  }
}
