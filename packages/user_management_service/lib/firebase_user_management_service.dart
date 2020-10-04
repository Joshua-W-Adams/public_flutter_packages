part of user_management_service;

/// [FirebaseUserManagementService] generates a listenable stream of a specific
/// users profile based on a passed user identifer (uid). This service is used
/// in conjunction with a [StreamBuilder] widget to rebuild its children based
/// on changes to the users profile. Typical uses of this class are are enforce
/// user email verification, subscription and onboarding checks. The generic
/// dart variable <T> is used for specifing the application specific User Model
/// that is constructed with the userBuilder callback function.
class FirebaseUserManagementService<T> {
  // generate instance of firestore database service to enable listening to
  // stream of user profile document on firebase
  final FirestoreService _firestoreService = FirestoreService.instance;
  final String uid;
  final User firebaseUser;
  // user model builders
  T Function(DocumentSnapshot userProfileDocument, User firebaseUser)
      userBuilder;
  // listenable user profile stream
  StreamController<T> _userStream = StreamController<T>();
  // last user profile document recieved from the firestore stream
  DocumentSnapshot _currentUser;
  // latest version of the firebase user object
  User _firebaseUser;

  FirebaseUserManagementService({
    @required this.uid,
    @required this.firebaseUser,
    @required this.userBuilder,
  }) {
    // set latest version of the firebase user
    _firebaseUser = firebaseUser;
    // open stream to users firestore profile
    _firestoreService.documentStream(
      // standard user collection structure
      path: 'users/$uid',
      builder: (userProfileSnapshot) {
        // builder fired in sync with firestore stream (everytime a property on
        // the user document changes)
        // potentially incorporate the following code in the future to have more
        // control over when the user stream emmits events.
        // if (_currentUser == null) {
        //   // case 1 - user logging in
        // } else {
        //   // case 2 - user already logged in
        //   // only emit the stream for specific user profile field changes
        // }
        // add to user stream
        _userStream.add(
          userBuilder(userProfileSnapshot, _firebaseUser),
        );
        // save a copy of the current user in cache
        _currentUser = userProfileSnapshot;
        // firestore stream not listened to. No return required.
        // return userProfileSnapshot;
      },
    );
  }

  Stream<T> get onUserStateChanged {
    return _userStream.stream;
  }

  void fireStream() {
    // refire the stream with the last firebase user profile recieved
    _userStream.add(
      userBuilder(_currentUser, _firebaseUser),
    );
  }

  // private variables for handling email verification timer checks
  Timer _timer;
  Timer _timeout;

  void refreshFirebaseUserData() async {
    // reload current user data
    await firebaseUser
      ..reload();
    // save firebase users data to object parameter
    _firebaseUser = await FirebaseAuth.instance.currentUser;
  }

  // initialise timer to check for verification status every 2 seconds
  void _checkForEmailVerificationStatus() {
    _timer = Timer.periodic(
      Duration(seconds: 2),
      (timer) async {
        // reload current user data
        refreshFirebaseUserData();
        // if user email is verified cancel timer
        if (firebaseUser.emailVerified) {
          // fire user management stream with updated firebase user object
          fireStream();
          disposeTimers();
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

  // kill timers when no longer required to prevent memory leaks
  void disposeTimers() {
    if (_timer != null) {
      _timer.cancel();
    }
    if (_timeout != null) {
      _timeout.cancel();
    }
  }
}
