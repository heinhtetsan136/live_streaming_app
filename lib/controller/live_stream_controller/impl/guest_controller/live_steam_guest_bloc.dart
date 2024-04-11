import 'package:fluttertoast/fluttertoast.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_event.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_state.dart';
import 'package:live_streaming/controller/live_stream_controller/impl/guest_controller/live_stream_guest_event.dart';
import 'package:live_streaming/controller/live_stream_controller/impl/guest_controller/live_stream_guest_state.dart';
import 'package:live_streaming/service/ui_live_strem/impl/live_stream_guest%20_servic.dart';
import 'package:live_streaming/service/ui_live_strem/model/livepayload.dart';
import 'package:logger/logger.dart';

class LiveStreamGuestBloc
    extends LiveStreamBaseBloc<LiveStreamBaseEvent, LiveStreamBaseState> {
  static final _logger = Logger();

  @override
  final LiveStreamGuestService service;
  LiveStreamGuestBloc(this.service, LivePayload payload)
      : super(const LiveStreamGuestInitialState(), service) {
    super.payload = payload;

    on<LiveStreamGuestSendComment>((_, emit) async {
      final comment = controller.text;
      if (comment.isEmpty) return;
      controller.clear();
      final result = await service.sendcomment(comment, super.payload!.liveID);
      _logger.i("comment $result");
      if (result.hasError) {
        Fluttertoast.showToast(msg: result.error!.messsage.toString());
      }
    });
    on<LiveStreamGuestJoinEvent>((event, emit) async {
      if (state is LiveStreamGuestJoiningState) return;

      emit(const LiveStreamGuestJoiningState());
      final token =
          await service.generateToken(payload.liveID, payload.channel);
      _logger.i("token is ${token.toString()}");
      if (token.hasError) {
        emit(
            LiveStreamGuestFailedToJoinState(token.error!.messsage.toString()));
        return;
      }
      print("guest bloc ${token.data['uid']},${token.data["token"]}");
      super.payload =
          payload.updateToken(token.data['uid'], token.data['token']);
      service.join(super.payload!.liveID);
    });
    add(const LiveStreamGuestJoinEvent());
  }
  @override
  void listener(bool? value) {
    if (value == null) return;
    if (value) {
      emit(const LiveStreamGuestJoinedState());
    } else {
      emit(const LiveStreamGuestFailedToJoinState("unknown error"));
    }
    // TODO: implement listener
  }

  @override
  Future<void> close() {
    service.dispose();

    // controller.dispose();
    // TODO: implement close
    return super.close();
  }
}
