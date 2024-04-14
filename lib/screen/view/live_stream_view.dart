import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_bloc.dart';
import 'package:live_streaming/service/agora_sevice/impl/agora_host_service.dart';

///Stateless
class LiveStreamVideo<T extends LiveStreamBaseBloc> extends StatelessWidget {
  const LiveStreamVideo({super.key});

  @override
  Widget build(BuildContext context) {
    final T livestreambloc = context.read<T>();

    // void a() {
    //   print(
    //       "value2 is ${livestreambloc.isClosed},${livestreambloc.service}${livestreambloc.state}${livestreambloc.toString()}");
    //   Future.delayed(const Duration(milliseconds: 100), a);
    // }

    // a();
    if (livestreambloc.agoraBaseService is AgoraHostService) {
      return AgoraVideoView(
        controller: livestreambloc.hostViewController,
      );
    }
    return StreamBuilder(
      stream: livestreambloc.guestLiveStreamConnection,
      builder: (_, snp) {
        print({
          "uiliveStream is ${livestreambloc.agoraBaseService.connection.toString()} ${livestreambloc.guestlivestreamlastconnection}"
        });

        final conn = livestreambloc.agoraBaseService.connection;

        if (conn == null) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        return AgoraVideoView(
          key: UniqueKey(),
          controller: VideoViewController.remote(
            rtcEngine: livestreambloc.engine,
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
