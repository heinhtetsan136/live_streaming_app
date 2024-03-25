abstract class LiveStreamBaseState {
  const LiveStreamBaseState();
}

class LiveStreamContentCreateInitalState extends LiveStreamBaseState {
  const LiveStreamContentCreateInitalState();
}

class LiveStreamContentCreateLoadingState extends LiveStreamBaseState {
  const LiveStreamContentCreateLoadingState();
}

class LiveStreamContentCreateSuccessState extends LiveStreamBaseState {
  const LiveStreamContentCreateSuccessState();
}

class LiveStreamContentCreateErrorState extends LiveStreamBaseState {
  final String message;
  const LiveStreamContentCreateErrorState(this.message);
}
