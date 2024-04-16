import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/auth_controller/auth_bloc.dart';
import 'package:live_streaming/controller/home_controller/home_page_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/impl/guest_controller/live_steam_guest_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/impl/host_controller/live_stream_host_bloc.dart';
import 'package:live_streaming/controller/live_view-controller/live_view_cubit.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/posts/post_bloc.dart';
import 'package:live_streaming/router/route_name.dart';
import 'package:live_streaming/screen/auth_screen.dart';
import 'package:live_streaming/screen/home/home_screen_base.dart';
import 'package:live_streaming/screen/live_stream_screen.dart';
import 'package:live_streaming/screen/view/post_create/post_create_screen.dart';
import 'package:live_streaming/screen/view/screen/profile_settings_screen.dart';
import 'package:live_streaming/screen/view/screen/setting_screen.dart';
import 'package:live_streaming/service/agora_sevice/impl/agora_guest_service.dart';
import 'package:live_streaming/service/agora_sevice/impl/agora_host_service.dart';
import 'package:live_streaming/service/auth_service.dart/auth_sevice.dart';
import 'package:live_streaming/service/ui_live_strem/impl/live_stream_guest%20_servic.dart';
import 'package:live_streaming/service/ui_live_strem/impl/live_stream_host_service.dart';
import 'package:live_streaming/service/ui_live_strem/model/livepayload.dart';

LiveStreamHostBloc _findHostBloc() {
  final isRegistered = Locator.isRegistered<LiveStreamHostBloc>();
  if (!isRegistered) {
    Locator.registerLazySingleton(() => LiveStreamHostBloc(
        LiveStreamHostService(), Locator<AgoraHostService>()));
  } else {
    Locator.resetLazySingleton<LiveStreamHostBloc>();
  }

  return Locator<LiveStreamHostBloc>();
}

Route<dynamic>? router(RouteSettings settings) {
  if (Locator<AuthService>().currentuser == null) {
    return _routebuilder(
        BlocProvider(create: (_) => AuthBloc(), child: const AuthScreen()),
        settings);
  }

  switch (settings.name) {
    case RouteNames.postCreate:
      late LiveStreamHostBloc value;
      final isRegistered = Locator.isRegistered<LiveStreamHostBloc>();
      if (!isRegistered) {
        Locator.registerLazySingleton(() => LiveStreamHostBloc(
            LiveStreamHostService(), Locator<AgoraHostService>()));
      } else {
        Locator.resetLazySingleton<LiveStreamHostBloc>();
      }
      value = Locator<LiveStreamHostBloc>();
      return _routebuilder(
        // const PostCreateScreen(),
        BlocProvider.value(
          value: _findHostBloc(),
          child: const PostCreateScreen(),
        ),
        settings,
      );
    case RouteNames.profilesettting:
      return _routebuilder(const ProfileSettingScreen(), settings);
    case RouteNames.settings:
      return _routebuilder(const SettingScreen(), settings);
    case RouteNames.host:
      // final value1 = settings.arguments;
      // print("value is ${value1.toString()}");
      // print("value loc ${Locator.isRegistered<LiveStreamHostBloc>()}");
      if (!Locator.isRegistered<LiveStreamHostBloc>()) {
        return _routebuilder(
          const Scaffold(
            body: Center(
              child: Text("Trya "),
            ),
          ),
          settings,
        );
      }
      final value = Locator<LiveStreamHostBloc>();
      return _routebuilder(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => LiveViewCubit()),
            BlocProvider.value(
              value: value,
            ),
          ],
          child: LiveStreamScreen<LiveStreamHostBloc>(
              service: Locator<AgoraHostService>()),
        ),
        settings,
      );
    // final value = settings.arguments;
    // if (value is! LiveStreamHostBloc) {
    //   return _routebuilder(
    //       const Scaffold(
    //         body: Center(
    //           child: Text("Trya "),
    //         ),
    //       ),
    //       settings);
    // }
    // return _routebuilder(
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider(create: (_) => LiveViewCubit()),
    //         BlocProvider.value(value: value),
    //       ],
    //       child: LiveStreamScreen<LiveStreamHostBloc>(
    //           service: Locator<AgoraHostService>()),
    //       // child: LiveStreamScreen<LiveStreamHostBloc>(
    //       //   service: Locator<AgoraHostService>(),
    //       // ),
    //     ),
    //     settings);

    case RouteNames.home:
      return _routebuilder(_buildHomePage(), settings);
    case RouteNames.view:
      final value = settings.arguments;
      if (value is! LivePayload) {
        return _routebuilder(
          const Scaffold(
            body: Center(
              child: Text("Trya "),
            ),
          ),
          settings,
        );
      }
      return _routebuilder(
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => LiveViewCubit(),
            ),
            BlocProvider(
              create: (_) => LiveStreamGuestBloc(LiveStreamGuestService(),
                  value, Locator<AgoraGuestService>()),
            )
          ],
          child: LiveStreamScreen<LiveStreamGuestBloc>(
            service: Locator<AgoraGuestService>(),
          ),
        ),
        settings,
      );
    default:
      return _routebuilder(_buildHomePage(),
          RouteSettings(name: RouteNames.home, arguments: settings.name));
  }
}

Widget _buildHomePage() {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => HomePageBloc()),
      BlocProvider(create: (_) => PostBloc()),
      BlocProvider(create: (_) => MyPostBloc())
    ],
    child: const HomeScreen(),
  );
}

Route _routebuilder(Widget screen, RouteSettings settings) {
  return MaterialPageRoute(builder: (_) => screen, settings: settings);
}
