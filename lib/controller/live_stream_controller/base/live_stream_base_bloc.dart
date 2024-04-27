import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_event.dart';
import 'package:live_streaming/service/agora_sevice/base/agora_base_service.dart';
import 'package:live_streaming/service/ui_live_strem/base/live_stream_base_service.dart';
import 'package:live_streaming/service/ui_live_strem/model/livepayload.dart';
import 'package:live_streaming/service/ui_live_strem/model/ui_livecomment.dart';

abstract class LiveStreamBaseBloc<S> extends Bloc<LiveStreamBaseEvent, S> {
  LivePayload? _livepayload;
  LivePayload? get livePayload => _livepayload;
  set paload(LivePayload? payload) {
    _livepayload = payload;
  }

  final LiveStreamBaseService service;

  final AgoraBaseService agoraBaseService;
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
    print("host base");
    print("payloaduser base ${livePayload.toString()}");
    on<LiveStreamInitEvent>((event, emit) async {
      connect();
      defaultSocketConnection();

      handler = AgoraHandler.fast();

      _subscription = service.stream.listen((value) {
        print("result value $value && ${_livepayload.toString()}");
        if (value == true && _livepayload != null) {
          _streamstatuslistener(true);
        }
        _streamstatuslistener(null);
      });
      await _subscription?.asFuture();
    });
    add(LiveStreamInitEvent());
  }
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  void _streamstatuslistener(
    bool? value,
  ) {
    print("result _stattus ${livePayload?.liveID}");
    // if (payload == null) {
    //   Future.delayed(const Duration(milliseconds: 500));
    //   _streamstatuslistener(value);
    // }
    final newstate = streamstatuslistener(value);
    if (newstate == null) return;
    print("trigger value is $value");
    emit(newstate);

    if (value == true) {
      print("result value is $value");
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
    print("result payloaduser ${_livepayload?.liveID}");

    final keep = _livepayload != null;
    print("keep is $keep");
    assert(keep);
    print("payloaduser assert ${_livepayload?.liveID}");
    await agoraBaseService.init();

    agoraBaseService.handler = handler;

    await agoraBaseService.ready();

    print("payloaduser c1 ${_livepayload?.liveID}");
    await agoraBaseService.live(
      _livepayload!.token,
      _livepayload!.channel,
      _livepayload!.userID,
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
