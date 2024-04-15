import 'package:flutter/material.dart';
import 'package:live_streaming/posts/post_bloc.dart';
import 'package:live_streaming/screen/home/home_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("My Profile"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
      ),
      body: const ShowPost<MyPostBloc>(),
    );
  }
}
