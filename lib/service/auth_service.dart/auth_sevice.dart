import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_streaming/core/error/error.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/service/agora_sevice/base/agora_base_service.dart';

class AuthService {
  final FirebaseAuth _auth;
  AuthService()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn.standard();
  final GoogleSignIn _googleSignIn;
  // final FacebookAuth _facebookAuth;
  User? get currentuser => _auth.currentUser;
  Stream<User?> userchanges() => _auth.userChanges();
  Future<Result<UserCredential>> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? result = await _googleSignIn.signIn();
      if (result == null) {
        return Result(error: GeneralError("Login Failed"));
      }
      final GoogleSignInAuthentication auth = await result.authentication;

      final credential = await loginWithCredential(
          GoogleAuthProvider.credential(accessToken: auth.accessToken));
      _googleSignIn.signOut();
      return credential;
    } on SocketException catch (e) {
      return Result(error: GeneralError(e.toString()));
    } catch (e) {
      return Result(error: GeneralError(e.toString()));
    }
  }

  Future<void> loginWithFacebook() async {}
  Future<Result<UserCredential>> loginWithCredential(
      OAuthCredential credential) async {
    try {
      final UserCredential result =
          await _auth.signInWithCredential(credential);
      Locator<FirebaseAuth>()
          .currentUser
          ?.getIdToken()
          .then((value) => AgoraBaseService.logger.d(value ?? ""));
      return Result(data: result);
    } on FirebaseAuthException catch (e) {
      return Result(error: GeneralError(e.code, e.stackTrace));
    } on SocketException catch (e) {
      return Result(error: GeneralError(e.message));
    } catch (e) {
      return Result(error: GeneralError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      ///
    }
  }
}
