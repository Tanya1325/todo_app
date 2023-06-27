import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:todo_app/utils/app_constants.dart';

import 'instances.dart';

Future<User?> signInWithGoogle({required BuildContext context}) async {
  User? user;
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      user = userCredential.user;
      debugPrint("user->$user");
    } on FirebaseAuthException catch (e) {
      debugPrint("Error-${e.toString()}");

      if (e.code == 'account-exists-with-different-credential') {
        showSimpleNotification(const Text(AppConstants.invalidCredentials),
            background: Colors.red);
      } else if (e.code == 'invalid-credential') {
        debugPrint("Error-${e.toString()}");
        showSimpleNotification(const Text(AppConstants.invalidCredentials),
            background: Colors.red);
      }
    } catch (e) {
      showSimpleNotification(const Text(AppConstants.invalidCredentials),
          background: Colors.red);
    }
  }
  return user;
}
