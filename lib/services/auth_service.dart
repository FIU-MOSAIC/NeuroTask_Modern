// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db   = FirebaseFirestore.instance;

  /// Creates the user in Firebase Auth, then writes extra fields to Firestore.
  Future<User?> registerWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String dob,
    required String diagnosis,
    required String activity
  }) async {
    // 1) Create the user in Firebase Auth
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user == null) return null;

    // 2) Save extra profile info in Firestore under collection 'users'
    await _db.collection('users').doc(user.uid).set({
      'firstName': firstName,
      'lastName':  lastName,
      'email':     email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return user;
  }
}
