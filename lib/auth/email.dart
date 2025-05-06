import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Creates a new user and returns the UserCredential object.
  Future<UserCredential> createUser({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );  
      log('Registered user UID: ${credential.user?.uid}');
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log(' The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
      rethrow;
    } catch (e) {
      log(' Registration error: $e');
      rethrow;
    }
  }

  /// Signs in an existing user and returns the UserCredential.
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );  
      log('Signed in user UID: ${credential.user?.uid}');
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
      rethrow;
    } catch (e) {
      log('Sign-in error: $e');
      rethrow;
    }
  }
}
