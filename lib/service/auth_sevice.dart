import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth;
  AuthService()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn.standard();
  final GoogleSignIn _googleSignIn;
  // final FacebookAuth _facebookAuth;

  Future<void> loginWithGoogle() async {
    final GoogleSignInAccount? result = await _googleSignIn.signIn();
    if (result == null) {
      return;
    }
    final GoogleSignInAuthentication auth = await result.authentication;
    await loginWithCredential(
        GoogleAuthProvider.credential(accessToken: auth.accessToken));
  }

  Future<void> loginWithFacebook() async {}
  Future<void> loginWithCredential(OAuthCredential credential) async {
    _auth.signInWithCredential(credential);
  }
}
