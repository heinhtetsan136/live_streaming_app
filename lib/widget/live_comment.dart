import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_streaming/models/comment.dart';

class LiveComment extends StatefulWidget {
  final Widget Function(BuildContext, Comments) builder;
  const LiveComment({super.key, required this.builder});

  @override
  State<LiveComment> createState() => _LiveCommentState();
}

class _LiveCommentState extends State<LiveComment> {
  final ScrollController controller = ScrollController();
  final List<Comments> data = [];
  late final Stream<List<Comments>> s =
      Stream.periodic(const Duration(seconds: 3), (v) {
    data.add(Comments("Hello ${data.length}" * (v + 1)));
    data.sort((a, b) {
      return a.createdAt.compareTo(b.createdAt);
    });
    return data;
  }).asBroadcastStream();
  StreamSubscription? subscription;
  @override
  void initState() {
    super.initState();
    subscription = s.listen((event) {
      controller.animateTo(0,
          duration: const Duration(microseconds: 500), curve: Curves.linear);
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    controller.dispose();
    super.dispose();
  }

  // late final Stream<List<Comments>> s =
  //     Stream.periodic(const Duration(seconds: 3), (v) {
  //   data.add(Comments("Hello ${data.length}" * (v + 1)));
  //   data.sort((p, c) => c.createdAt.compareTo(p.createdAt));
  //   return data;
  // }).asBroadcastStream();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: s,
        builder: (_, snap) {
          final result = snap.data ?? [];
          return ListView.separated(
              reverse: true,
              controller: controller,
              itemBuilder: (_, index) {
                return widget.builder(context, result[index]);
              },
              separatorBuilder: (_, i) => const SizedBox(
                    height: 15,
                  ),
              itemCount: result.length);
        });
  }
}
