import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_bloc.dart';
import 'package:live_streaming/service/ui_live_strem/impl/live_stream_host_service.dart';
import 'package:live_streaming/service/ui_live_strem/model/ui_livecomment.dart';
import 'package:logger/logger.dart';
import 'package:starlight_utils/starlight_utils.dart';

final _logger = Logger();

class LiveComments<T extends LiveStreamBaseBloc> extends StatelessWidget {
  final Widget Function(BuildContext context, UiLiveStreamComment comment)
      builder;
  const LiveComments({
    super.key,
    required this.builder,
  });

  // late final Stream<List<Comments>> s =
  //     Stream.periodic(const Duration(seconds: 3), (v) {
  //   data.add(Comments("Hello ${data.length}" * (v + 1)));
  //   data.sort((p, c) => c.createdAt.compareTo(p.createdAt));
  //   return data;
  // }).asBroadcastStream();

  @override
  Widget build(BuildContext context) {
    final T livestream = context.read<T>();
    return PageView(
      physics: const PageScrollPhysics(),
      onPageChanged: (index) {
        if (index == 0) {
          livestream.livecomment;
        }
      },
      children: [
        StreamBuilder<List<UiLiveStreamComment>>(
          stream: livestream.livecomment,
          builder: (_, snapshot) {
            _logger.i(
                "this is comment {${livestream.service} ${snapshot.data.toString()},{${livestream.service}");

            final result = snapshot.data ?? [];

            _logger.i("this is comment length ${result.length}");
            // _logger.i("this is comment ${snapshot.data.toString()}");
            return ListView.separated(
              reverse: true,
              controller: livestream.commentcontroller,
              padding: EdgeInsets.only(
                bottom: livestream.service is LiveStreamHostService ? 20 : 120,
                top: 20,
              ),
              separatorBuilder: (_, i) => const SizedBox(
                height: 15,
              ),
              itemCount: result.length,
              itemBuilder: (_, index) {
                return builder(context, result[index]);
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
