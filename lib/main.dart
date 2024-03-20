import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/live_view-controller/live_view_cubit.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/router/route_name.dart';
import 'package:live_streaming/router/router.dart';
import 'package:live_streaming/service/base/agora_base_service.dart';
import 'package:live_streaming/service/impl/agora_host_service.dart';
import 'package:live_streaming/themes/light_theme.dart';

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
    final AppLightTheme appLightTheme = AppLightTheme();
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => LiveViewCubit())],
      child: MaterialApp(
        // home: LiveStreamScreen(agoraBaseService: service),

        onGenerateRoute: router,
        initialRoute: RouteNames.auth,
        theme: appLightTheme.theme,
      ),
    );
  }
}
