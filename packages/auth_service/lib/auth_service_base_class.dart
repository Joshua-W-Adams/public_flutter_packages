part of auth_service;

abstract class AuthService {
  // user authentication stream
  Stream get onAuthStateChanged;
  // user sign in methods
  Future<void> signInAnonymously();
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<void> signInWithGoogle();
  // Future<void> signInWithFacebook();
  Future<void> signInWithApple();
  Future<void> signOut();
  // user creation methods
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
}
