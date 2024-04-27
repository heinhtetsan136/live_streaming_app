import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_event.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_state.dart';
import 'package:live_streaming/controller/live_stream_controller/impl/host_controller/live_stream_host_event.dart';
import 'package:live_streaming/controller/live_stream_controller/impl/host_controller/live_stream_host_state.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:live_streaming/service/agora_sevice/impl/agora_host_service.dart';
import 'package:live_streaming/service/ui_live_strem/impl/live_stream_host_service.dart';
import 'package:live_streaming/service/ui_live_strem/model/livepayload.dart';

class LiveStreamHostBloc extends LiveStreamBaseBloc<LiveStreamBaseState> {
  LiveStreamHostService get liveStreamHostService => service;

  // LiveStreamHostService service;
  // static final _logger = Logger();
  @override
  final AgoraHostService agoraHostService;
  @override
  final TextEditingController controller = TextEditingController();
  @override
  final FocusNode focusNode = FocusNode();
  // final LiveStreamHostService service = Locator<LiveStreamHostService>();
  GlobalKey<FormState>? formkey = GlobalKey();

  @override
  LiveStreamBaseState? streamstatuslistener(bool? event) {
    if (event == null) return null;
    print("result start live stream $event");
    if (event) {
      return const LiveStreamContentCreateSuccessState();
      // _logger.e("error is error $event");
    }
    return const LiveStreamContentCreateErrorState("failed to lived");
  }

  @override
  final LiveStreamHostService service;
  LiveStreamHostBloc(this.service, this.agoraHostService)
      : super(const LiveStreamContentCreateInitalState(), service,
            agoraHostService) {
    // _logger.i(state);

    on<LiveStreamContentCreateEvent>((event, emit) async {
      print("result state $state");
      if (state is LiveStreamContentCreateLoadingState) return;
      emit(const LiveStreamContentCreateLoadingState());
      final Result<LivePayload> result =
          await service.postCreate(controller.text);
      if (result.hasError) {
        // _logger.e("error1 is error ${result.error.toString()}");
        emit(LiveStreamContentCreateErrorState(
            result.error!.messsage.toString()));
        return;
      }
      // _logger.i("result host${result.data.liveID}");

      paload = result.data;

      print("result state $state");
      print("result pay d${livePayload!.liveID.toString()}");

      service.startLiveStream(livePayload!.liveID);
      // await service.init();
      // emit(const LiveStreamContentCreateSuccessState());
    });
    on<LiveSteamEndEvent>((event, emit) async {
      assert(livePayload != null);
      print("end event");
      print("end1");
      final result = await service.endLiveStream(livePayload!.liveID);

      // _logger.i("enddd  ${result.toString()}");
      if (result.hasError) {
        Fluttertoast.showToast(msg: "${result.error}");
        return;
      }
      // StarlightUtils.pop();
      Fluttertoast.showToast(msg: "sucessfully end");
    });
  }

  @override
  void readystate(bool value) {
    if (value) {
      emit(const LiveStreamPostCreateReady());
    } else {
      // _logger.e("error2 is error $value");
      emit(const LiveStreamContentCreateErrorState("Connection Time OUt"));
    }

    // TODO: implement readystate
  }

  @override
  void defaultSocketConnection() {
    on<LiveStreamSocketConnectEvent>((_, emit) {
      emit(const LiveStreamContentCreateInitalState());
      super.connect();
    });
    // TODO: implement defaultSocketConnection
  }
}
