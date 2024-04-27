abstract class LiveStreamBaseEvent {
  const LiveStreamBaseEvent();
}

class LiveStreamSocketConnectEvent extends LiveStreamBaseEvent {
  const LiveStreamSocketConnectEvent();
}

class LiveStreamInitEvent extends LiveStreamBaseEvent {
  LiveStreamInitEvent();
}
