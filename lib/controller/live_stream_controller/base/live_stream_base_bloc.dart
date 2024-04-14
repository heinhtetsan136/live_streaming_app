import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/service/agora_sevice/base/agora_base_service.dart';
import 'package:live_streaming/service/ui_live_strem/base/live_stream_base_service.dart';
import 'package:live_streaming/service/ui_live_strem/model/livepayload.dart';
import 'package:live_streaming/service/ui_live_strem/model/ui_livecomment.dart';

abstract class LiveStreamBaseBloc<E, S> extends Bloc<E, S> {
  LivePayload? payload;
  final LiveStreamBaseService service;

  AgoraBaseService agoraBaseService;
  Stream<AgoraLiveConnection?> get guestLiveStreamConnection =>
      agoraBaseService.onLive.stream;
  AgoraLiveConnection? get guestlivestreamlastconnection =>
      agoraBaseService.connection;
  VideoViewController get hostViewController =>
      agoraBaseService.videoViewcontroller;

  RtcEngine get engine => agoraBaseService.engine;
  // VideoViewController get hostVideoView => agoraservice.videoViewcontroller;
  late final AgoraHandler handler;
  StreamSubscription? _subscription;
  LiveStreamBaseBloc(super.initialState, this.service, this.agoraBaseService) {
    connect();
    defaultSocketConnection();

    handler = AgoraHandler.fast();

    _subscription = service.stream.listen((value) {
      _streamstatuslistener(value);
    });
  }
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  void _streamstatuslistener(
    bool? value,
  ) {
    final newstate = streamstatuslistener(value);
    if (newstate == null) return;
    print("trigger value is $value");
    emit(newstate);
    if (value == true) {
      _streamStatusTrigger();
    }
    return;
  }

  S? streamstatuslistener(bool? value);
  void defaultSocketConnection();
  void readystate(bool value);
  void connect() {
    print("connect socket");
    service.isSocketReady.then(readystate).timeout(const Duration(seconds: 5),
        onTimeout: () {
      readystate(false);
    });
  }

  Future<void> _streamStatusTrigger() async {
    print("this is _streamStatusTrigger");
    print("payload ${payload.toString()}");
    assert(payload != null);

    await agoraBaseService.init();

    agoraBaseService.handler = handler;

    await agoraBaseService.ready();
    // Future.delayed(const Duration(milliseconds: 200));

    await agoraBaseService.live(
      payload!.token,
      payload!.channel,
      payload!.userID,
    );
    _commentStreamSubscription = service.comment.listen(_loadcomment);
  }

  Stream<List<UiLiveStreamComment>> get livecomment => service.comment;
  void _loadcomment(event) {
    (event) {
      // data.sort((p, c) {
      //   return p.createdAt.compareTo(c.createdAt);
      // });
      commentcontroller.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    };
  }

  final ScrollController commentcontroller = ScrollController();

  StreamSubscription? _commentStreamSubscription;
  @override
  Future<void> close() async {
    await _commentStreamSubscription?.cancel();
    commentcontroller.dispose();
    controller.dispose();
    await _subscription?.cancel();
    await agoraBaseService.close();
    focusNode.dispose();
    // service.dispose();
    // service.dispose();

    // TODO: implement close
    return super.close();
  }
}
