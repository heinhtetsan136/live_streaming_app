import 'package:flutter/material.dart';
import 'package:live_streaming/posts/post_bloc.dart';
import 'package:live_streaming/router/route_name.dart';
import 'package:live_streaming/screen/home/home_view.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profile"),
        actions: [
          IconButton(
              onPressed: () {
                print("settings page");
                StarlightUtils.pushNamed(RouteNames.settings);
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: const ShowPost<MyPostBloc>(),
      floatingActionButton: const PostCreatedButton(),
    );
  }
}
