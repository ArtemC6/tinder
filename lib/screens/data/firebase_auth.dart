import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;

  FirebaseAuthMethods(this._auth);

  User get user => _auth.currentUser!;

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        // showAlertDialogLoad(context);
        final docUser = FirebaseFirestore.instance
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser!.uid);

        final json = {
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'name': name,
          'email': email,
          'password': password,
        };
        docUser.set(json);

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Manager()));
      }).onError((error, stackTrace) {
        // Navigator.pop(context);
      });
    } on FirebaseAuthException {}
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Manager()));
      })
          .onError((error, stackTrace) {
        // showAlertDialogLoad(context);
        // Navigator.pop(context);
      });
    } on FirebaseAuthException {}
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException {}
  }
}
