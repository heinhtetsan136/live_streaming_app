import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_streaming/firebase_options.dart';
import 'package:live_streaming/service/agora_sevice/impl/agora_guest_service.dart';
import 'package:live_streaming/service/agora_sevice/impl/agora_host_service.dart';
import 'package:live_streaming/service/auth_service.dart/auth_sevice.dart';
import 'package:live_streaming/service/frebase/firestore.dart';
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
  Locator.registerLazySingleton(() => AuthService());
  Locator.registerLazySingleton(() => FirebaseStorage.instance);
  Locator.registerLazySingleton(() => FirebaseFirestore.instance);
  Locator.registerLazySingleton(() => ImagePicker());

  Locator.registerLazySingleton(() => SettingService());

  final Agorahostservice = await AgoraHostService.instance();
  final Agoraguestservice = await AgoraGuestService.instance();
  Locator.registerLazySingleton<AgoraHostService>(() => Agorahostservice);
  Locator.registerLazySingleton<AgoraGuestService>(() => Agoraguestservice);

  final dio = Dio();
  Locator.registerLazySingleton(() => dio);
  Locator.registerLazySingleton(() => SearchPostService());
  Locator.registerLazySingleton(() => PostService());
  Locator.registerLazySingleton(() => MyPostService());
}
