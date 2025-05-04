import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._auth, this._firestore);

  Future<void> register(String email, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'email': email,
    });
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }
}
