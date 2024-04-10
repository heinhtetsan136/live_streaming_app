import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_state.dart';

class LiveStreamGuestInitialState extends LiveStreamBaseState {
  const LiveStreamGuestInitialState();
}

class LiveStreamGuestJoinedState extends LiveStreamBaseState {
  const LiveStreamGuestJoinedState();
}

class LiveStreamGuestFailedToJoinState extends LiveStreamBaseState {
  final String message;
  const LiveStreamGuestFailedToJoinState(this.message);
}

class LiveStreamGuestJoiningState extends LiveStreamBaseState {
  const LiveStreamGuestJoiningState();
}
