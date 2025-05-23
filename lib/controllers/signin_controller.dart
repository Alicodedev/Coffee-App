import 'package:firebase_auth/firebase_auth.dart';
import '../models/signin_model.dart';

class SigninController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      // Handle error (e.g., wrong password, user not found)
      rethrow;
    }
  }
}