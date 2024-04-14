import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_bloc.dart';
import 'package:live_streaming/service/ui_live_strem/impl/live_stream_host_service.dart';
import 'package:live_streaming/service/ui_live_strem/model/ui_livecomment.dart';
import 'package:logger/logger.dart';
import 'package:starlight_utils/starlight_utils.dart';

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
  Stream<List<UiLiveStreamComment>> get getcommentstream {
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   _loaddata(data);
    // });
    return livestream.service.comment;
  }
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
    subscription = livestream.service.comment.listen(_loaddata);
  }

  @override
  void dispose() {
    subscription?.cancel();
    controller.dispose();
    super.dispose();
  }

  void _loaddata(event) {
    (event) {
      data.clear();
      data.addAll(event);
      // data.sort((p, c) {
      //   return p.createdAt.compareTo(c.createdAt);
      // });
      controller.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    };
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const PageScrollPhysics(),
      onPageChanged: (index) {
        if (index == 0) {
          livestream.service.comment;
        }
      },
      children: [
        StreamBuilder<List<UiLiveStreamComment>>(
          stream: getcommentstream,
          builder: (_, snapshot) {
            _logger.i(
                "this is comment {${livestream.service} ${snapshot.data.toString()},{${livestream.service}");

            final result = snapshot.data ?? [];
            _logger.i("this is data ${data.map((e) => e.comment)}");
            _logger.i("this is comment length ${result.length}");
            // _logger.i("this is comment ${snapshot.data.toString()}");
            return ListView.separated(
              reverse: true,
              controller: controller,
              padding: EdgeInsets.only(
                bottom: livestream.service is LiveStreamHostService ? 20 : 120,
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
        Container(
          color: const Color.fromRGBO(225, 255, 255, 0.001),
          width: context.width,
          height: context.height,
        )
      ],
    );
  }
}
