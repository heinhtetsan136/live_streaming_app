import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/service/base/agora_base_service.dart';
import 'package:live_streaming/service/live_strem/model.dart';

abstract class LiveStreamBaseBloc<E, S> extends Bloc<E, S> {
  LivePayload? payload;
  LiveStreamBaseBloc(super.initialState) {
    handler = AgoraHandler.fast();
  }
  late final AgoraHandler handler;
}
