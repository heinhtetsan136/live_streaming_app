import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/auth_controller/auth_bloc.dart';
import 'package:live_streaming/controller/home_controller/home_page_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/live_stream_bloc.dart';
import 'package:live_streaming/controller/live_view-controller/live_view_cubit.dart';
import 'package:live_streaming/controller/post/post_bloc.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/router/route_name.dart';
import 'package:live_streaming/screen/auth_screen.dart';
import 'package:live_streaming/screen/home/home_screen.dart';
import 'package:live_streaming/screen/live_stream_screen.dart';
import 'package:live_streaming/screen/view/post_create/post_create_screen.dart';
import 'package:live_streaming/service/auth_sevice.dart';
import 'package:live_streaming/service/impl/agora_guest_service.dart';
import 'package:live_streaming/service/impl/agora_host_service.dart';
import 'package:live_streaming/service/live_strem/live_stream_service.dart';

Route<dynamic>? router(RouteSettings settings) {
  if (Locator<AuthService>().currentuser == null) {
    return _routebuilder(
        BlocProvider(create: (_) => AuthBloc(), child: const AuthScreen()),
        settings);
  }

  switch (settings.name) {
    case RouteNames.postCreate:
      return _routebuilder(
        // const PostCreateScreen(),
        BlocProvider(
          create: (_) => LiveStreamHostBloc(LiveStreamService.instance()),
          child: const PostCreateScreen(),
        ),
        settings,
      );
    case RouteNames.host:
      final value = settings.arguments;
      if (value is! LiveStreamHostBloc) {
        return _routebuilder(
            const Scaffold(
              body: Center(
                child: Text("Trya "),
              ),
            ),
            settings);
      }
      return _routebuilder(
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => LiveViewCubit()),
              BlocProvider.value(value: value),
            ],
            child: LiveStreamScreen<LiveStreamHostBloc>(
                service: Locator<AgoraHostService>()),
            // child: LiveStreamScreen<LiveStreamHostBloc>(
            //   service: Locator<AgoraHostService>(),
            // ),
          ),
          settings);
    case RouteNames.home:
      return _routebuilder(_buildHomePage(), settings);
    case RouteNames.view:
      return _routebuilder(
          LiveStreamScreen(service: Locator<AgoraGuestService>()), settings);
    default:
      return _routebuilder(_buildHomePage(),
          RouteSettings(name: RouteNames.home, arguments: settings.name));
  }
}

Widget _buildHomePage() {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => HomePageBloc()),
      BlocProvider(create: (_) => PostBloc())
    ],
    child: const HomeScreen(),
  );
}

Route _routebuilder(Widget screen, RouteSettings settings) {
  return MaterialPageRoute(builder: (_) => screen, settings: settings);
}
