import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth auth;
  AuthRepository(this.auth);

  Stream<User?> authStateChanges() => auth.authStateChanges();

  Future<void> signIn(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => auth.signOut();

  bool get isLoggedIn => auth.currentUser != null;
}
