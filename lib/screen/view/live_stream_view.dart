import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:live_streaming/service/base/agora_base_service.dart';
import 'package:live_streaming/service/impl/agora_host_service.dart';

class LiveStreamVideoView extends StatefulWidget {
  final AgoraBaseService service;
  const LiveStreamVideoView({super.key, required this.service});

  @override
  State<LiveStreamVideoView> createState() => _LiveStreamVideoViewState();
}

class _LiveStreamVideoViewState extends State<LiveStreamVideoView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  void dispose() {
    widget.service.close();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> init() async {
    await widget.service.init();
    widget.service.handler = AgoraHandler.fast();
    // widget.service.handler = AgoraHandler(
    //     onError: (msg, str) {},
    //     onLeaveChannel: (connection, status) {},
    //     onRejoinChannelSuccess: (connection, _) {},
    //     onUserJoined: (con, remoteUid, _) {},
    //     onUserOffline: (con, remoteuid, _) {},
    //     onJoinChannelSuccess: (con, _) {},
    //     onTokenPrivilegeWillExpire: (con, token) {});
    await widget.service.ready();
    await widget.service.live("lkjkj", "test");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.service.onLive.stream,
        builder: (_, snap) {
          if (widget.service is AgoraHostService) {
            return AgoraVideoView(
              onAgoraVideoViewCreated: (uid) => print("aavvc is $uid"),
              controller: widget.service.videoViewcontroller,
            );
          }
          if (widget.service.connection != null) {
            return AgoraVideoView(
              onAgoraVideoViewCreated: (uid) => print("aavvc is $uid"),
              controller: widget.service is AgoraHostService
                  ? widget.service.videoViewcontroller
                  : VideoViewController.remote(
                      rtcEngine: widget.service.engine,
                      canvas: VideoCanvas(
                        uid: widget.service.connection!.remoteId,
                      ),
                      connection: widget.service.connection!.connection),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
