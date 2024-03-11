import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_streaming/locator.dart';
import 'package:lottie/lottie.dart';
import 'package:starlight_utils/starlight_utils.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final google = GoogleSignIn.standard();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(252, 92, 99, 116),
              Color.fromARGB(249, 132, 122, 216),
              Color.fromARGB(250, 81, 66, 214),
            ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
            width: context.width,
            height: context.height,
            child: Lottie.asset("assets/image/lottie/login_screen.json",
                fit: BoxFit.contain),
          ),
          Positioned(
              left: 20,
              right: 20,
              bottom: 110,
              child: Center(
                child: SizedBox(
                  width: context.width,
                  height: 50,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      onPressed: () async {
                        await google.signOut();
                        final GoogleSignInAccount? account =
                            await google.signIn();
                        final GoogleSignInAuthentication? authentication =
                            await account?.authentication;
                        authentication?.idToken;

                        Locator<FirebaseAuth>().signInWithCredential(
                            GoogleAuthProvider.credential(
                                accessToken: authentication?.accessToken));
                      },
                      child: const Text("Login with google")),
                ),
              )),
          // Positioned(
          //     left: 20,
          //     right: 20,
          //     bottom: 50,
          //     child: Center(
          //       child: SizedBox(
          //         width: context.width,
          //         height: 50,
          //         child: ElevatedButton(
          //             style: ButtonStyle(
          //                 shape: MaterialStatePropertyAll(
          //                     RoundedRectangleBorder(
          //                         borderRadius: BorderRadius.circular(10)))),
          //             onPressed: () {},
          //             child: const Text("Login with facebook")),
          //       ),
          //     ))
        ],
      ),
      //     body: Center(
      //   child: ElevatedButton(
      //       onPressed: () async {

      //         print(Locator<FirebaseAuth>().currentUser.toString());
      //       },
      //       child: const Text("Login with Google")),
      // )
    );
  }
}
