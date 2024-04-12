import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/service/agora_sevice/base/agora_base_service.dart';
import 'package:live_streaming/service/ui_live_strem/base/live_stream_base_service.dart';
import 'package:live_streaming/service/ui_live_strem/model/livepayload.dart';

abstract class LiveStreamBaseBloc<E, S> extends Bloc<E, S> {
  LivePayload? payload;
  final LiveStreamBaseService service;
  late final AgoraHandler handler;
  StreamSubscription? _subscription;
  LiveStreamBaseBloc(super.initialState, this.service) {
    connect();
    defaultSocketConnection();

    handler = AgoraHandler.fast();

    _subscription = service.stream.listen(listener);
  }
  TextEditingController controller = TextEditingController();
  void listener(bool? value);
  void defaultSocketConnection();
  void readystate(bool value);
  void connect() {
    print("connect socket");
    service.isSocketReady.then(readystate).timeout(const Duration(seconds: 5),
        onTimeout: () {
      readystate(false);
    });
  }

  @override
  Future<void> close() {
    controller.dispose();
    // _subscription?.cancel();
    // service.dispose();

    // TODO: implement close
    return super.close();
  }
}
