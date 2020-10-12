part of auth_service;

/// Model to store authentication credentials to be linked to a existing email
/// account in firebasebase authentication
class LinkCredentials {
  String email;
  List<String> providers;
  AuthCredential credentialToLink;

  LinkCredentials({
    @required this.email,
    @required this.providers,
    @required this.credentialToLink,
  });
}

/// Authentication service for handling authorised access to the application
/// Allows authorisation via email/pass, Facebook and Google as identity providers
class FirebaseAuthService implements AuthService {
  // generate instance of firebase authentication
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // 3rd party authentication module instances
  // final fb = FacebookLogin();
  // final FacebookLogin _facebookLogin = FacebookLogin();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // create new stream that checks for authorisation state changes
  StreamController<User> _authStream = StreamController<User>();

  FirebaseAuthService() {
    // listen to the on auth state changed stream
    _firebaseAuth.authStateChanges().listen(
      (User user) async {
        _authStream.add(user);
      },
    );
  }

  // master stream that the parent provider of the application is listening to.
  // application will be rebuilt when updates from firebase are issued through
  // this stream.
  // getter - defined using the get keyword - allows retrieval of a value from a class
  Stream<User> get onAuthStateChanged {
    return _authStream.stream;
  }

  // ********************************** sign in methods **********************************

  /// Note: All sign in methods do not return user objects. This is due to the fact that
  /// the authentication stream is always fired on authentication state changes which reinjects
  /// the application specific user model into the app.
  ///
  Future<void> signInAnonymously({
    AuthCredential authCredentialtoLink,
  }) async {
    await _firebaseAuth.signInAnonymously();
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password, {
    AuthCredential authCredentialtoLink,
  }) async {
    AuthCredential credential;
    // attempt to sign in and link credentials if passed
    try {
      // get email credentials to sign in with
      credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      // sign into firebase with these credentials
      final UserCredential authResult =
          await _firebaseAuth.signInWithCredential(
        credential,
      );
      // save user result
      User user = authResult.user;
      // user logged into firebase
      if (user != null && authCredentialtoLink != null) {
        // if authorisation credetials from a different provider passed. Link them.
        user.linkWithCredential(authCredentialtoLink);
      }
    } catch (error) {
      if (error is PlatformException &&
          error.code == "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL") {
        // fetch available providers for the email
        List<String> providers = await _firebaseAuth.fetchSignInMethodsForEmail(
          email,
        );
        // store account linking details
        LinkCredentials linkCredentials = LinkCredentials(
          email: email,
          providers: providers,
          credentialToLink: credential,
        );
        // throw error so link with account credentials page can be triggered
        throw PlatformException(
          code: "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL",
          message:
              "Account exists with different credentials. Please log in with the correct account provider.",
          details: linkCredentials,
        );
      }
      // else throw error with default configuration
      rethrow;
    }
  }

  Future<void> signInWithGoogle({
    AuthCredential authCredentialtoLink,
  }) async {
    User user;
    GoogleSignInAccount googleUser;
    AuthCredential credential;
    // flag to check whether current\ google user is already signed in
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      // user = await _firebaseAuth.currentUser();
      // sign out of google to allow the user to selct a new account to sign into the application with
      _googleSignIn.signOut();
    }
    try {
      // initiate the sign-in workflow by calling the _googleSignIn.signIn() method
      // which pops up a web view in our Flutter app that handles the capturing of
      // the user’s Google credentials in a secure manner
      googleUser = await _googleSignIn.signIn();
      //     .catchError((onError) {
      //   throw PlatformException(
      //     code: 'GOOGLE_LOGIN_ERROR',
      //     message: onError,
      //   );
      // });
      if (googleUser != null) {
        // From the googleUser we extract the authentication pieces we need
        // ... the accessToken and idToken
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        // create credentials object for signing into firebase
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // finally sign into the firebase application using the google accounts credentials.
        user = (await _firebaseAuth.signInWithCredential(credential)).user;
        // user logged into firebase
        if (user != null && authCredentialtoLink != null) {
          // if authorisation credetials from a different provider passed. Link them.
          user.linkWithCredential(authCredentialtoLink);
        }
      } else {
        throw PlatformException(
          code: 'GOOGLE_LOGIN_ERROR',
          message: 'Error in google sign in.',
        );
      }
    } catch (error) {
      if (error is PlatformException) {
        if (error.code == "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL") {
          String email = googleUser.email;
          // fetch available providers for the email
          List<String> providers =
              await _firebaseAuth.fetchSignInMethodsForEmail(email);
          // store account linking details
          LinkCredentials linkCredentials = LinkCredentials(
            email: email,
            providers: providers,
            credentialToLink: credential,
          );
          // throw error so link with account credentials page can be triggered
          throw PlatformException(
            code: "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL",
            message:
                "Account exists with different credentials. Please log in with the correct account provider.",
            details: linkCredentials,
          );
        }
        // else throw error with default configuration
        rethrow;
      } else {
        throw PlatformException(
          code: 'GOOGLE_LOGIN_ERROR',
          message: 'Something went wrong with the login process.\n'
              'Here\'s the error Google gave us: ${error.toString()}',
        );
      }
    }
  }

  // Future<void> signInWithFacebook({
  //   AuthCredential authCredentialtoLink,
  // }) async {
  //   // hold the instance of the authenticated firebase user
  //   User user;

  //   // Force the users to login using the login dialog based on WebViews.
  //   fb.loginBehavior = FacebookLoginBehavior.webViewOnly;

  //   // log user out of existing facebook account
  //   fb.logOut();

  //   // commence the facebook authorisation using the OAuth standard
  //   final result = await fb.logIn(['email']);

  //   switch (result.status) {
  //     case FacebookLoginStatus.loggedIn:
  //       final FacebookAccessToken accessToken = result.accessToken;
  //       // print('''
  //       //  Logged in!

  //       //  Token: ${accessToken.token}
  //       //  User id: ${accessToken.userId}
  //       //  Expires: ${accessToken.expires}
  //       //  Permissions: ${accessToken.permissions}
  //       //  Declined permissions: ${accessToken.declinedPermissions}
  //       //  ''');

  //       AuthCredential credential =
  //           FacebookAuthProvider.credential(accessToken.token);
  //       try {
  //         user = (await _firebaseAuth.signInWithCredential(credential)).user;
  //         // if authorisation credetials from a different provider passed. Link them.
  //         if (user != null && authCredentialtoLink != null) {
  //           user.linkWithCredential(authCredentialtoLink);
  //         }
  //       } catch (error) {
  //         if (error is PlatformException &&
  //             error.code == "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL") {
  //           // fetch users details from facebook graph api
  //           var graphResponse = await http.get(
  //               'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}');
  //           // parse json response to object
  //           Map<String, dynamic> map = jsonDecode(graphResponse.body);
  //           // get email address
  //           String email = map['email'];
  //           // fetch providers for the email
  //           List<String> providers =
  //               await _firebaseAuth.fetchSignInMethodsForEmail(email);
  //           // store details for linking credentials
  //           LinkCredentials linkCredentials = LinkCredentials(
  //             email: email,
  //             providers: providers,
  //             credentialToLink: credential,
  //           );
  //           // throw exception so link with credentials page can be generated
  //           throw PlatformException(
  //             code: "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL",
  //             message:
  //                 "Account exists with different credentials. Please log in with the correct account provider.",
  //             details: linkCredentials,
  //           );
  //         }
  //         // re throw error to allow catching by other functions
  //         rethrow;
  //       }
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       throw PlatformException(
  //         code: 'FB_USER_CANCELED_LOGIN',
  //         message: 'Login cancelled by the user.',
  //       );
  //       break;
  //     case FacebookLoginStatus.error:
  //       throw PlatformException(
  //         code: 'FB_UNKNOWN_LOGIN_ERROR',
  //         message: 'Something went wrong with the login process.\n'
  //             'Here\'s the error Facebook gave us: ${result.errorMessage}',
  //       );
  //       break;
  //   }
  // }

  // Future<void> signInWithFacebook({
  //   AuthCredential authCredentialtoLink,
  // }) async {
  //   // facebook login not supported by web.
  //   if (kIsWeb) {
  //     // throw stops current function execution
  //     throw PlatformException(
  //       code: 'LOGIN_METHOD_NOT_SUPPORTED_ON_WEB',
  //       message:
  //           'Sign in with Facebook is currently not supported on web. Please select one of the other sign in methods.',
  //     );
  //   }

  //   // hold the instance of the authenticated firebase user
  //   User user;

  //   // Force the users to login using the login dialog based on WebViews.
  //   _facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

  //   // log user out of existing facebook account
  //   _facebookLogin.logOut();

  //   // commence the facebook authorisation using the OAuth standard
  //   final result = await _facebookLogin.logIn(['email']);

  //   switch (result.status) {
  //     case FacebookLoginStatus.loggedIn:
  //       final FacebookAccessToken accessToken = result.accessToken;
  //       // print('''
  //       //  Logged in!

  //       //  Token: ${accessToken.token}
  //       //  User id: ${accessToken.userId}
  //       //  Expires: ${accessToken.expires}
  //       //  Permissions: ${accessToken.permissions}
  //       //  Declined permissions: ${accessToken.declinedPermissions}
  //       //  ''');

  //       AuthCredential credential =
  //           FacebookAuthProvider.credential(accessToken.token);
  //       try {
  //         user = (await _firebaseAuth.signInWithCredential(credential)).user;
  //         // if authorisation credetials from a different provider passed. Link them.
  //         if (user != null && authCredentialtoLink != null) {
  //           user.linkWithCredential(authCredentialtoLink);
  //         }
  //       } catch (error) {
  //         if (error is PlatformException &&
  //             error.code == "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL") {
  //           // fetch users details from facebook graph api
  //           var graphResponse = await http.get(
  //               'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}');
  //           // parse json response to object
  //           Map<String, dynamic> map = jsonDecode(graphResponse.body);
  //           // get email address
  //           String email = map['email'];
  //           // fetch providers for the email
  //           List<String> providers =
  //               await _firebaseAuth.fetchSignInMethodsForEmail(email);
  //           // store details for linking credentials
  //           LinkCredentials linkCredentials = LinkCredentials(
  //             email: email,
  //             providers: providers,
  //             credentialToLink: credential,
  //           );
  //           // throw exception so link with credentials page can be generated
  //           throw PlatformException(
  //             code: "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL",
  //             message:
  //                 "Account exists with different credentials. Please log in with the correct account provider.",
  //             details: linkCredentials,
  //           );
  //         }
  //         // re throw error to allow catching by other functions
  //         rethrow;
  //       }
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       throw PlatformException(
  //         code: 'FB_USER_CANCELED_LOGIN',
  //         message: 'Login cancelled by the user.',
  //       );
  //       break;
  //     case FacebookLoginStatus.error:
  //       throw PlatformException(
  //         code: 'FB_UNKNOWN_LOGIN_ERROR',
  //         message: 'Something went wrong with the login process.\n'
  //             'Here\'s the error Facebook gave us: ${result.errorMessage}',
  //       );
  //       break;
  //   }
  // }

  Future<void> signInWithApple({
    AuthCredential authCredentialtoLink,
  }) async {
    // login not supported by web.
    if (kIsWeb) {
      // throw stops current function execution
      throw PlatformException(
        code: 'LOGIN_METHOD_NOT_SUPPORTED_ON_WEB',
        message:
            'Sign in with Apple is currently not supported on web. Please select one of the other sign in methods.',
      );
    }

    // commence the apple authorisation
    final AuthorizationCredentialAppleID appleIdCredential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oAuthProvider = OAuthProvider('apple.com');
    final credential = oAuthProvider.credential(
      idToken: appleIdCredential.identityToken,
      accessToken: appleIdCredential.authorizationCode,
    );

    try {
      User user = (await _firebaseAuth.signInWithCredential(credential)).user;
      // if authorisation credetials from a different provider passed. Link them.
      if (user != null && authCredentialtoLink != null) {
        user.linkWithCredential(authCredentialtoLink);
      }
    } catch (error) {
      if (error is PlatformException &&
          error.code == "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL") {
        // get email address
        String email = appleIdCredential.email;
        // fetch providers for the email
        List<String> providers =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        // store details for linking credentials
        LinkCredentials linkCredentials = LinkCredentials(
          email: email,
          providers: providers,
          credentialToLink: credential,
        );
        // throw exception so link with credentials page can be generated
        throw PlatformException(
          code: "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL",
          message:
              "Account exists with different credentials. Please log in with the correct account provider.",
          details: linkCredentials,
        );
      }
      // re throw error to allow catching by other functions
      rethrow;
    }
  }

  // ********************************** Sign Out methods **********************************
  Future<void> signOut() async {
    // if auth service is down force user object to be null
    _authStream.add(null);
    return _firebaseAuth.signOut();
  }

  // ********************************** Email Password Specific Methods *******************
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final UserCredential authResult =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // user created
    if (authResult.user != null) {
      try {
        // send verification email to user account
        authResult.user.sendEmailVerification();
      } catch (error) {
        // print(error);
      }
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // ********************************** Email Verfication Methods *******************

  // private variables for handling email verification timer checks
  Timer _timer;
  Timer _timeout;
  User _firebaseUser;

  void addToAuthStream() {
    // refire the stream with the last firebase user profile recieved
    _authStream.add(_firebaseUser);
  }

  // initialise timer to check for verification status every 2 seconds
  void checkForEmailVerificationStatus() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) async {
        // reload current user data
        await _firebaseAuth.currentUser
          ..reload();
        _firebaseUser = _firebaseAuth.currentUser;
        // if user email is verified cancel timer
        if (_firebaseUser.emailVerified) {
          // refresh id token to ensure updated email verified status is sent
          // with all requests.
          // force refresh of token claim
          // await _firebaseAuth.currentUser.getIdToken(true);
          // fire user management stream with updated firebase user object
          addToAuthStream();
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
      checkForEmailVerificationStatus();
    }
    // send verification email from firebase.
    await _firebaseUser.sendEmailVerification();
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
