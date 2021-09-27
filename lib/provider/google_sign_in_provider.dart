import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool? _isSigningIn;
  String? guserId;
  String? gtoken;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn!;
  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future login() async {
    isSigningIn = true;

    final user = await googleSignIn.signIn();

    if (user == null) {
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        guserId = value.user!.uid;
        gtoken = value.user!.getIdToken().toString();
       
      });

      isSigningIn = false;
    }
    notifyListeners();
  }

  void logout() async {
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
    }
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
