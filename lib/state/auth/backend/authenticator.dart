import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instant_gram/main.dart';
import 'package:instant_gram/state/auth/constants/constants.dart';
import 'package:instant_gram/state/auth/models/auth_result.dart';
import 'package:instant_gram/state/posts/typedefs/user_id.dart';

class Authenticator {
  var auth = FirebaseAuth.instance;
  UserId? get userId => auth.currentUser?.uid;

  bool get isAlreadyLoggedIn => userId != null;

  String get displayName => auth.currentUser?.displayName ?? '';

  String? get email => auth.currentUser?.email;

  Future<void> logOut() async {
    await auth.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    if (kDebugMode) {
      print('logged out');
    }
  }

  Future<AuthResult> loginWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();

    final token = loginResult.accessToken?.token;

    if (token == null) {
      //user aborted login process
      return AuthResult.aborted;
    }

    final oAuthCredential = FacebookAuthProvider.credential(token);

    try {
      await auth.signInWithCredential(
        oAuthCredential,
      );
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      final email = e.email;
      final credential = e.credential;
      // email?.log();
      print(email);
      credential?.log();

      if (e.code == Constants.accountExistWithDifferentCredential &&
          email != null &&
          credential != null) {
        final providers = await auth.fetchSignInMethodsForEmail(email);

        if (providers.contains(Constants.googleCom)) {
          await loginWithGoogle();

          auth.currentUser?.linkWithCredential(
            credential,
          );
        }
        return AuthResult.success;
      }
      e.code.log();

      return AuthResult.failure;
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        Constants.emailScope,
      ],
    );

    final signInAccount = await googleSignIn.signIn();

    if (signInAccount == null) {
      return AuthResult.aborted;
    }

    final googleAuth = await signInAccount.authentication;

    final oAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      await auth.signInWithCredential(oAuthCredential);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.failure;
    }
  }
}
