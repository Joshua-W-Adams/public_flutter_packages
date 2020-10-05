part of user_management_service;

/// [FirebaseUserManagementService] generates a listenable stream of a specific
/// users profile based on a passed user identifer (uid). This service is used
/// in conjunction with a [StreamBuilder] widget to rebuild its children based
/// on changes to the users profile. Typical uses of this class are are enforce
/// user  subscription and onboarding checks. The generic dart variable <T> is
/// used for specifing the application specific User Model that is constructed
/// with the userBuilder callback function.
class FirebaseUserManagementService<T> {
  // generate instance of firestore database service to enable listening to
  // stream of user profile document on firebase
  final FirestoreService _firestoreService = FirestoreService.instance;
  final String uid;
  // user model builders
  T Function(DocumentSnapshot userProfileDocument) userBuilder;
  // listenable user profile stream
  StreamController<T> _userStream = StreamController<T>();
  // last user profile document recieved from the firestore stream
  // DocumentSnapshot _currentUser;

  FirebaseUserManagementService({
    @required this.uid,
    @required this.userBuilder,
  }) {
    // open stream to users firestore profile
    _firestoreService
        .documentStream(
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
            _userStream.add(userBuilder(userProfileSnapshot));
            // save a copy of the current user in cache
            // _currentUser = userProfileSnapshot;
            // firestore stream not listened to. No return required.
            // return userProfileSnapshot;
          },
          // listen to stream to start the stream
        )
        .listen(
          (data) {},
        );
  }

  Stream<T> get onUserStateChanged {
    return _userStream.stream;
  }
}
