import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/live_stream_base_bloc.dart';
import 'package:live_streaming/service/base/agora_base_service.dart';
import 'package:live_streaming/service/impl/agora_host_service.dart';

///Stateless
class LiveStreamVideo<T extends LiveStreamBaseBloc> extends StatefulWidget {
  //BLOC
  final AgoraBaseService service;
  const LiveStreamVideo({
    super.key,
    required this.service,
  });

  @override
  State<LiveStreamVideo> createState() => _LiveStreamVideoState<T>();
}

class _LiveStreamVideoState<T extends LiveStreamBaseBloc>
    extends State<LiveStreamVideo> {
  late final T livestreambloc = context.read<T>();
  // late final T liveStreamBloc = context.read<T>();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await widget.service.init();

    widget.service.handler = livestreambloc.handler;

    await widget.service.ready();
    Future.delayed(const Duration(milliseconds: 200));

    final payload = livestreambloc.payload!;

    await widget.service.live(
      payload.token,
      payload.channel,
      payload.userID,
    );
  }

  @override
  void dispose() {
    widget.service.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.service.onLive.stream,
      builder: (_, snp) {
        if (widget.service is AgoraHostService) {
          return AgoraVideoView(
            controller: widget.service.videoViewcontroller,
          );
        }
        final conn = widget.service.connection;
        if (conn == null) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        return AgoraVideoView(
          controller: widget.service is AgoraHostService
              ? widget.service.videoViewcontroller
              : VideoViewController.remote(
                  rtcEngine: widget.service.engine,
                  canvas: VideoCanvas(
                    uid: conn.remoteId,
                  ),
                  connection: conn.connection,
                ),
        );
      },
    );
  }
}
