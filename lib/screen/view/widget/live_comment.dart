import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_bloc.dart';
import 'package:live_streaming/service/ui_live_strem/model/ui_livecomment.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

class LiveComments<T extends LiveStreamBaseBloc> extends StatefulWidget {
  final Widget Function(BuildContext context, UiLiveStreamComment comment)
      builder;
  const LiveComments({
    super.key,
    required this.builder,
  });

  @override
  State<LiveComments> createState() => _LiveCommentsState<T>();
}

class _LiveCommentsState<T extends LiveStreamBaseBloc>
    extends State<LiveComments> {
  final ScrollController controller = ScrollController();
  late final T livestream = context.read<T>();
  final List<UiLiveStreamComment> data = [];
  Stream<List<UiLiveStreamComment>> get s => livestream.service.comment;
  // late final Stream<List<Comments>> s =
  //     Stream.periodic(const Duration(seconds: 3), (v) {
  //   data.add(Comments("Hello ${data.length}" * (v + 1)));
  //   data.sort((p, c) => c.createdAt.compareTo(p.createdAt));
  //   return data;
  // }).asBroadcastStream();

  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    subscription = livestream.service.comment.listen((event) {
      data.clear();
      data.addAll(event);
      // data.sort((p, c) {
      //   return p.createdAt.compareTo(c.createdAt);
      // });
      controller.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        StreamBuilder<List<UiLiveStreamComment>>(
          stream: s,
          builder: (_, snapshot) {
            _logger.i("this is comment ${snapshot.data.toString()}");

            final result = snapshot.data ?? [];

            return ListView.separated(
              reverse: true,
              controller: controller,
              padding: const EdgeInsets.only(
                bottom: 120,
                top: 20,
              ),
              separatorBuilder: (_, i) => const SizedBox(
                height: 15,
              ),
              itemCount: result.length,
              itemBuilder: (_, index) {
                return widget.builder(context, result[index]);
              },
            );
          },
        ),
        const SizedBox()
      ],
    );
  }
}
