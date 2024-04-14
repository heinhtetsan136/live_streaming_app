import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_event.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_state.dart';
import 'package:live_streaming/controller/live_stream_controller/impl/host_controller/live_stream_host_event.dart';
import 'package:live_streaming/controller/live_stream_controller/impl/host_controller/live_stream_host_state.dart';
import 'package:live_streaming/service/ui_live_strem/impl/live_stream_host_service.dart';
import 'package:live_streaming/service/ui_live_strem/model/livepayload.dart';
import 'package:starlight_utils/starlight_utils.dart';

class LiveStreamHostBloc
    extends LiveStreamBaseBloc<LiveStreamBaseEvent, LiveStreamBaseState> {
  LiveStreamHostService get liveStreamHostService => service;
  // LiveStreamHostService service;
  // static final _logger = Logger();
  @override
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  // final LiveStreamHostService service = Locator<LiveStreamHostService>();
  GlobalKey<FormState>? formkey = GlobalKey();
  @override
  LivePayload? payload;
  @override
  void listener(bool? event) {
    if (event == null) return;
    print("start live stream $event");
    if (!event) {
      // _logger.e("error is error $event");
      emit(const LiveStreamContentCreateErrorState("failed to lived"));
      return;
    }
    emit(const LiveStreamContentCreateSuccessState());
  }

  @override
  final LiveStreamHostService service;
  LiveStreamHostBloc(this.service)
      : super(const LiveStreamContentCreateInitalState(), service) {
    // _logger.i(state);

    on<LiveStreamContentCreateEvent>((event, emit) async {
      if (state is LiveStreamContentCreateLoadingState) return;
      emit(const LiveStreamContentCreateLoadingState());
      final result = await service.postCreate(controller.text);
      if (result.hasError) {
        // _logger.e("error1 is error ${result.error.toString()}");
        emit(LiveStreamContentCreateErrorState(
            result.error!.messsage.toString()));
        return;
      }
      // _logger.i(result.data);

      payload = result.data;
      service.startLiveStream(payload!.liveID);
      // await service.init();
      // emit(const LiveStreamContentCreateSuccessState());
    });
    on<LiveSteamEndEvent>((event, emit) async {
      assert(payload != null);
      print("end event");
      print("end1");
      final result = await service.endLiveStream(payload!.liveID);

      // _logger.i("enddd  ${result.toString()}");
      if (result.hasError) {
        Fluttertoast.showToast(msg: "${result.error}");
        return;
      }
      StarlightUtils.pop();
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
  Future<void> close() {
    // service.dispose();
    print("close host");
    // controller.dispose();
    // TODO: implement close
    return super.close();
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
