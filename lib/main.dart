import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/live_view-controller/live_view_cubit.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/router/route_name.dart';
import 'package:live_streaming/router/router.dart';
import 'package:live_streaming/service/agora_sevice/base/agora_base_service.dart';
import 'package:live_streaming/service/agora_sevice/impl/agora_host_service.dart';
import 'package:live_streaming/service/frebase/firestore.dart';
import 'package:live_streaming/themes/light_theme.dart';
import 'package:starlight_utils/starlight_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Hello World");

  await setup();
  // Locator<FirebaseAuth>().signOut();
  runApp(MyApp(
    service: Locator<AgoraHostService>(),
  ));
}

class MyApp extends StatelessWidget {
  final AgoraBaseService service;
  const MyApp({super.key, required this.service});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final SettingService settingService = Locator<SettingService>();
    final AppLightTheme appLightTheme = AppLightTheme();
    final AppDarkTheme appDarkTheme = AppDarkTheme();
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => LiveViewCubit())],
      child: StreamBuilder(
          stream: settingService.setting(),
          builder: (_, snap) {
            final isDark = snap.data?.theme == "dark";
            print("theme $isDark");
            return MaterialApp(
              // home: LiveStreamScreen(agoraBaseService: service),
              navigatorKey: StarlightUtils.navigatorKey,
              onGenerateRoute: router,
              initialRoute: RouteNames.auth,
              darkTheme: appDarkTheme.theme,
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            );
          }),
    );
  }
}
