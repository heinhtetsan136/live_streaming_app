import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:live_streaming/controller/home_controller/home_page_bloc.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/service/auth_sevice.dart';
import 'package:starlight_utils/starlight_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homepagebloc = context.read<HomePageBloc>();
    return Scaffold(
      body: PageView.builder(
          controller: homepagebloc.controller,
          itemCount: 3,
          itemBuilder: (_, i) {
            return ListView(
              children: [Container()],
            );
          }),
      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final homepagebloc = context.read<HomePageBloc>();
    final authservice = Locator<AuthService>();
    return BlocBuilder<HomePageBloc, int>(builder: (_, state) {
      return GNav(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        activeColor: context.theme.bottomNavigationBarTheme.selectedItemColor,
        color: context.theme.bottomNavigationBarTheme.unselectedItemColor,
        onTabChange: (value) {
          homepagebloc.add(homepagebloc.activate(value));
        },
        selectedIndex: state,
        tabs: [
          const GButton(
            icon: Icons.access_alarms,
            gap: 10,
            text: "Home",
          ),
          const GButton(
            icon: Icons.search,
            gap: 10,
            text: "Search",
          ),
          GButton(
            icon: Icons.person_off_outlined,
            leading: StreamBuilder(
                stream: Locator<AuthService>().userchanges(),
                builder: (_, snap) {
                  final String? url = snap.data?.photoURL;
                  if (url == null) {
                    return const Center(
                      child: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    );
                  }
                  return CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(url),
                  );
                }),
            gap: 10,
            text: authservice.currentuser?.displayName ??
                authservice.currentuser?.email ??
                "User",
          ),
        ],
      );
    });
  }
}
