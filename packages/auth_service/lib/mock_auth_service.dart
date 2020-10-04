part of auth_service;

@immutable
class MockUser {
  final String uid;
  final String email;

  const MockUser({
    @required this.uid,
    this.email,
  });
}

class _UserData {
  _UserData({@required this.password, @required this.user});
  final String password;
  final MockUser user;
}

/// Mock authentication service to be used for testing the UI
/// Keeps an in-memory store of registered accounts so that registration and
/// sign in flows can be tested.
class MockAuthService implements AuthService {
  final Duration startupTime;
  final Duration responseTime;
  final Map<String, _UserData> _usersStore = <String, _UserData>{};
  final StreamController<MockUser> _onAuthStateChangedController =
      StreamController<MockUser>();

  MockAuthService({
    this.startupTime = const Duration(milliseconds: 250),
    this.responseTime = const Duration(seconds: 1),
  }) {
    Future<void>.delayed(responseTime).then((_) {
      _add(null);
    });
  }

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) {
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) {
          return _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          );
        },
      ),
    );
  }

  Stream<MockUser> get onAuthStateChanged {
    return _onAuthStateChangedController.stream;
  }

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await Future<void>.delayed(responseTime);
    if (_usersStore.keys.contains(email)) {
      throw PlatformException(
        code: 'ERROR_EMAIL_ALREADY_IN_USE',
        message: 'The email address is already registered. Sign in instead?',
      );
    }
    final MockUser user = MockUser(uid: getRandomString(32), email: email);
    _usersStore[email] = _UserData(password: password, user: user);
    _add(user);
    return user;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await Future<void>.delayed(responseTime);
    if (!_usersStore.keys.contains(email)) {
      throw PlatformException(
        code: 'ERROR_USER_NOT_FOUND',
        message: 'The email address is not registered. Need an account?',
      );
    }
    final _UserData _userData = _usersStore[email];
    if (_userData.password != password) {
      throw PlatformException(
        code: 'ERROR_WRONG_PASSWORD',
        message: 'The password is incorrect. Please try again.',
      );
    }
    _add(_userData.user);
    return _userData.user;
  }

  Future<void> sendPasswordResetEmail(String email) async {}

  Future<void> signInWithEmailAndLink({String email, String link}) async {
    await Future<void>.delayed(responseTime);
    final MockUser user = MockUser(uid: getRandomString(32));
    _add(user);
    return user;
  }

  Future<void> signOut() async {
    _add(null);
  }

  void _add(MockUser user) {
    _onAuthStateChangedController.add(user);
  }

  Future<void> signInAnonymously() async {
    await Future<void>.delayed(responseTime);
    final MockUser user = MockUser(uid: getRandomString(32));
    _add(user);
    return user;
  }

  Future<void> signInWithFacebook() async {
    await Future<void>.delayed(responseTime);
    final MockUser user = MockUser(uid: getRandomString(32));
    _add(user);
    return user;
  }

  Future<void> signInWithGoogle() async {
    await Future<void>.delayed(responseTime);
    final MockUser user = MockUser(uid: getRandomString(32));
    _add(user);
    return user;
  }

  Future<void> signInWithApple() async {
    await Future<void>.delayed(responseTime);
    final MockUser user = MockUser(uid: getRandomString(32));
    _add(user);
    return user;
  }
}
