import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'const.dart';

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
      showAlertDialogLoading(context);
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        final docUser = FirebaseFirestore.instance
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser?.uid);

        final json = {
          'uid': FirebaseAuth.instance.currentUser?.uid,
          'name': name,
          'email': email,
          'myPol': '',
          'imageBackground': '',
          'myCity': '',
          'searchPol': '',
          'rangeStart': 0,
          'rangeEnd': 0,
          'ageTime': DateTime.now(),
          'ageInt': 0,
          'listInterests': [],
          'listImagePath': [],
          'listImageUri': [],
        };
        docUser.set(json);

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Manager()));
      }).onError((error, stackTrace) {
        Navigator.pop(context);
      });
    } on FirebaseAuthException {}
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      showAlertDialogLoading(context);
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Manager()));
      }).onError((error, stackTrace) {
        Navigator.pop(context);
      });
    } on FirebaseAuthException {}
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException {}
  }
}
