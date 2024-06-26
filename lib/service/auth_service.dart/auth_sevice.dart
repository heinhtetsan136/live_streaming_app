import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_streaming/core/error/error.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:live_streaming/locator.dart';

class AuthService {
  final FirebaseAuth _auth;
  final ImagePicker _imagepicker;
  final FirebaseStorage _database;
  AuthService()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn.standard(),
        _imagepicker = Locator<ImagePicker>(),
        _database = Locator<FirebaseStorage>();
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
      // Locator<FirebaseAuth>()
      //     .currentUser
      //     ?.getIdToken()
      //     .then((value) => AgoraBaseService.logger.d(value ?? ""));
      return Result(data: result);
    } on FirebaseAuthException catch (e) {
      return Result(error: GeneralError(e.code, e.stackTrace));
    } on SocketException catch (e) {
      return Result(error: GeneralError(e.message));
    } catch (e) {
      return Result(error: GeneralError(e.toString()));
    }
  }

  Future<void> UpdateDisplayName(String name) async {
    await currentuser?.updateDisplayName(name);
  }

  Future<void> UpdateProfile() async {
    final user = currentuser;
    if (user == null) return;
    final image = await _imagepicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final oldimage = user.photoURL;
    if (oldimage?.startsWith("users/") == true) {
      await _database.ref(oldimage).delete();
    }
    final profilePath = "users/${user.uid}_${DateTime.now().toIso8601String()}";
    await _database.ref(profilePath).putFile(File(image.path));
    await user.updatePhotoURL(profilePath);
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      ///
    }
  }
}
