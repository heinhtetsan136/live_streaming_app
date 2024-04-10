import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_streaming/controller/auth_controller/auth_bloc.dart';
import 'package:live_streaming/controller/auth_controller/auth_event.dart';
import 'package:live_streaming/controller/auth_controller/auth_state.dart';
import 'package:live_streaming/router/route_name.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:starlight_utils/starlight_utils.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  static final _logger = Logger();
  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
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
                        authBloc.add(const LoginWithGoogleEvent());
                        // await google.signOut();
                        // final GoogleSignInAccount? account =
                        //     await google.signIn();
                        // final GoogleSignInAuthentication? authentication =
                        //     await account?.authentication;
                        // authentication?.idToken;

                        // Locator<FirebaseAuth>().signInWithCredential(
                        //     GoogleAuthProvider.credential(
                        //         accessToken: authentication?.accessToken));
                        // Locator<FirebaseAuth>().currentUser?.getIdToken().then(
                        //     (value) => AgoraBaseService.logger.i(value ?? ""));
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
          BlocConsumer<AuthBloc, LoginState>(
            listener: (_, state) {
              if (state is! LoginSucessState && state is! LoginErrorState) {
                return;
              }
              if (state is LoginErrorState) {
                Fluttertoast.showToast(msg: state.message ?? "Unknown");
                return;
              }
              StarlightUtils.pushReplacementNamed(RouteNames.home);
            },
            builder: (_, state) {
              if (state is LoginLoadingState) {
                return Container(
                  width: context.width,
                  height: context.height,
                  color: const Color.fromARGB(20, 29, 27, 27),
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              }
              return const SizedBox();
            },
          )
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
