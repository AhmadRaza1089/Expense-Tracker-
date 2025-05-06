import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class GitAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Call this once in main():
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await Firebase.initializeApp();
  Future<UserCredential?> signInWithGitHub() async {
    try {
      // Create a new provider
      GithubAuthProvider githubProvider = GithubAuthProvider();
      
      // Sign in with GitHub provider
      return await _auth.signInWithProvider(githubProvider);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      log('FirebaseAuth error (${e.code}): ${e.message}');
      rethrow;
    } catch (e, stack) {
      // Handle all other errors
      log('GitHub sign-in failed: $e\n$stack');
      rethrow;
    }
  }

  /// Sign out from Firebase
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log('Firebase signOut error: $e');
      rethrow;
    }
  }

  /// Check if user is currently signed in
  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  /// Get current user information
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}