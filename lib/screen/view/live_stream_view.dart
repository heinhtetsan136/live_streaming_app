import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_bloc.dart';
import 'package:live_streaming/service/agora_sevice/base/agora_base_service.dart';
import 'package:live_streaming/service/agora_sevice/impl/agora_host_service.dart';
import 'package:logger/logger.dart';

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
  static final _logger = Logger();
  T get livestreambloc => context.read<T>();
  // late final T liveStreamBloc = context.read<T>();

  @override
  void initState() {
    super.initState();
    if (mounted) init();
  }

  Future<void> init() async {
    await widget.service.init();
    _logger.i("init");
    widget.service.handler = livestreambloc.handler;
    _logger.wtf("handler: ${livestreambloc.handler.toString()}");

    await widget.service.ready();
    // Future.delayed(const Duration(milliseconds: 200));

    final payload = livestreambloc.payload!;
    _logger.i("screen token ${payload.toString()}");
    await widget.service.live(
      payload.token,
      payload.channel,
      payload.userID,
    );
  }

  @override
  Widget build(BuildContext context) {
    void a() {
      print(
          "value2 is ${livestreambloc.isClosed},${livestreambloc.service}${livestreambloc.state}${livestreambloc.toString()}");
      Future.delayed(const Duration(milliseconds: 100), a);
    }

    a();
    if (widget.service is AgoraHostService) {
      return AgoraVideoView(
        controller: widget.service.videoViewcontroller,
      );
    }
    return StreamBuilder(
      stream: widget.service.onLive.stream,
      builder: (_, snp) {
        print({"uiliveStream is ${widget.service.toString()}"});

        final conn = widget.service.connection;
        _logger.i("connectconn ${conn.toString()}");
        if (conn == null) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        return AgoraVideoView(
          key: UniqueKey(),
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
