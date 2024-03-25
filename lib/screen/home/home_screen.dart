import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:live_streaming/controller/home_controller/home_page_bloc.dart';
import 'package:live_streaming/controller/post/post_bloc.dart';
import 'package:live_streaming/controller/post/post_state.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/models/post.dart';
import 'package:live_streaming/router/route_name.dart';
import 'package:live_streaming/service/auth_sevice.dart';
import 'package:live_streaming/service/post/post_service.dart';
import 'package:starlight_utils/starlight_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final postservice = Locator<PostService>();
    final homepagebloc = context.read<HomePageBloc>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          StarlightUtils.pushNamed(RouteNames.postCreate);
        },
        child: const Icon(Icons.edit),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("LiveStream Project"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: BlocBuilder<PostBloc, PostBaseState>(
        builder: (_, state) {
          final posts = state.post;
          if (state is PostLoadingState) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: postservice.refresh,
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 10),
              separatorBuilder: (_, i) => const SizedBox(
                height: 10,
              ),
              itemCount: posts.length,
              itemBuilder: (_, i) {
                final post = posts[i];

                return PostCard(
                  post: post,
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  int get contentLength => post.content.length;

  bool get isActive => post.status == "on_going";

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final screenWidth = context.width;
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    post.profilePhoto,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.displayName,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      DateTime.now().differenceTimeInString(post.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
              bottom: 20,
            ),
            child: Text(
              post.content.substring(
                0,
                contentLength > 200 ? 200 : contentLength,
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            width: screenWidth,
            height: 150,
            alignment: Alignment.center,
            decoration:
                const BoxDecoration(color: Color.fromRGBO(82, 76, 76, 0.098)),
            child: GestureDetector(
              onTap: () {
                if (!isActive) {
                  Fluttertoast.showToast(
                    msg: "End",
                    // textColor: Colors.black,
                    // backgroundColor: const Color.fromRGBO(82, 76, 76, 0.098),
                  );
                  return;
                }
                StarlightUtils.pushNamed(RouteNames.view);
                // StarlightUtils.pushNamed(
                //   // RouteNames.view,
                //   // arguments: LivePayload(
                //   //   userID: post.userId,
                //   //   liveID: post.liveId,
                //   //   channel: post.channel,
                //   //   token: "",
                //   ),
                // );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(80),
                ),
                width: 60,
                height: 60,
                child: Icon(
                  Icons.play_arrow,
                  color: theme.cardTheme.color,
                  size: 40,
                ),
              ),
            ),
          ),
          Row(
            children: [
              const Expanded(
                child: CardActionButton(
                  icon: Icons.thumb_up,
                ),
              ),
              const Expanded(
                child: CardActionButton(
                  icon: Icons.comment,
                ),
              ),
              Expanded(
                child: CardActionButton(
                  label: post.viewCount.toString(),
                  icon: Icons.remove_red_eye,
                ),
              ),
            ],
          )
        ],
      ),
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

class CardActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const CardActionButton({
    super.key,
    this.icon = Icons.thumb_up,
    this.label = "like",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
