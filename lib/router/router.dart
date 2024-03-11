

// Route<dynamic>? router(RouteSettings settings) {
//   switch (settings.name)  {
//     case RouteNames.home:
//       return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//               create: (_) => LiveViewCubit(), child:  LiveStreamScreen(agoraBaseService: AgoraHostService.instance(),)),
//           settings: settings);

//     default:
//       return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//               create: (_) => LiveViewCubit(), child: const LiveStreamScreen()),
//           settings: settings);
//   }
// }
