import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as developer;

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    try {
      developer.log('Starting Google Sign-In process', name: 'GoogleAuthService');
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        developer.log('Google Sign-In aborted by user', name: 'GoogleAuthService');
        throw FirebaseAuthException(
          code: 'sign-in-canceled',
          message: 'Sign in was canceled by user'
        );
      }
      
      developer.log('Google user signed in: ${googleUser.email}', name: 'GoogleAuthService');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      developer.log('Obtained Google authentication', name: 'GoogleAuthService');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      developer.log('Created Firebase credential from Google auth', name: 'GoogleAuthService');

      // Once signed in, return the UserCredential
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      developer.log('Successfully signed in with Firebase: ${userCredential.user?.uid}', name: 'GoogleAuthService');
      
      return userCredential;
    } catch (e) {
      developer.log('Error during Google sign-in: $e', name: 'GoogleAuthService', error: e);
      rethrow; // Rethrow to allow handling in the UI
    }
  }

  Future<void> signOut() async {
    try {
      developer.log('Starting sign out process', name: 'GoogleAuthService');
      
      // Sign out from Google
      await _googleSignIn.signOut();
      developer.log('Signed out from Google', name: 'GoogleAuthService');
      
      // Sign out from Firebase
      await _auth.signOut();
      developer.log('Signed out from Firebase', name: 'GoogleAuthService');
    } catch (e) {
      developer.log('Error during sign out: $e', name: 'GoogleAuthService', error: e);
      rethrow;
    }
  }
}