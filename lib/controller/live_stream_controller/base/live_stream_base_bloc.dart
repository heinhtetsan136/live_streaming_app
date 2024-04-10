import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/service/base/agora_base_service.dart';
import 'package:live_streaming/service/ui_live_strem/base/live_stream_base_service.dart';
import 'package:live_streaming/service/ui_live_strem/model/livepayload.dart';

abstract class LiveStreamBaseBloc<E, S> extends Bloc<E, S> {
  LivePayload? payload;
  final LiveStreamBaseService service;
  late final AgoraHandler handler;
  StreamSubscription? _subscription;
  LiveStreamBaseBloc(super.initialState, this.service) {
    handler = AgoraHandler.fast();
    _subscription = service.stream.listen(listener);
  }
  void listener(bool value);
  @override
  Future<void> close() {
    _subscription?.cancel();
    service.dispose();

    // TODO: implement close
    return super.close();
  }
}