import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/live_stream_event.dart';
import 'package:live_streaming/controller/live_stream_controller/live_stream_state.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/service/live_strem/live_stream_service.dart';
import 'package:live_streaming/service/live_strem/model.dart';
import 'package:logger/logger.dart';

class LiveStreamBloc extends Bloc<LiveStreamBaseEvent, LiveStreamBaseState> {
  static final _logger = Logger();
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final LiveStreamHostService service = Locator<LiveStreamHostService>();
  GlobalKey<FormState>? formkey = GlobalKey();
  LivePayload? payload;
  LiveStreamBloc() : super(const LiveStreamContentCreateInitalState()) {
    on<LiveStreamContentCreateEvent>((event, emit) async {
      if (state is LiveStreamContentCreateLoadingState) return;
      emit(const LiveStreamContentCreateLoadingState());
      final result = await service.postCreate(controller.text);
      if (result.hasError) {
        emit(LiveStreamContentCreateErrorState(
            result.error!.messsage.toString()));
        return;
      }
      _logger.i(result.data);

      payload = result.data;
      emit(const LiveStreamContentCreateSuccessState());
    });
  }
  @override
  Future<void> close() {
    controller.dispose();
    focusNode.dispose();
    formkey = null;
    // TODO: implement close
    return super.close();
  }
}
