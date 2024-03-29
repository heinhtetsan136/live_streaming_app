import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:live_streaming/firebase_options.dart';
import 'package:live_streaming/service/auth_sevice.dart';
import 'package:live_streaming/service/impl/agora_guest_service.dart';
import 'package:live_streaming/service/impl/agora_host_service.dart';
import 'package:live_streaming/service/post/post_service.dart';

GetIt Locator = GetIt.asNewInstance();

Future<void> setup() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  await FirebaseAppCheck.instance
      // Your personal reCaptcha public key goes here:
      .activate(
    androidProvider: AndroidProvider.debug,
    // appleProvider: AppleProvider.debug,
    // webProvider: ReCaptchaV3Provider(kWebRecaptchaSiteKey),
  );
  final Agorahostservice = await AgoraHostService.instance();
  final Agoraguestservice = await AgoraGuestService.instance();
  Locator.registerLazySingleton<AgoraHostService>(() => Agorahostservice);
  Locator.registerLazySingleton<AgoraGuestService>(() => Agoraguestservice);
  Locator.registerLazySingleton(() => AuthService());
  final dio = Dio();
  Locator.registerLazySingleton(() => dio);
  Locator.registerLazySingleton(() => PostService());
}
