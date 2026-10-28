import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogInService {
  static FirebaseAuth mAuth;
  static FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  // Anonymous sign-in: no credentials shipped in the app.
  // Access is restricted by firestore.rules / storage.rules (read-only).
  getCurrentUser() async {
    mAuth = FirebaseAuth.instance;
    if (mAuth.currentUser != null) return;
    try {
      await mAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      print('Anonymous sign-in failed: ${e.code}');
    }
  }
}
