import 'package:live_streaming/locator.dart';
import 'package:live_streaming/service/auth_sevice.dart';
import 'package:live_streaming/util/const/post_base_url.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LiveStreamUtilService {
  final List<String> _listener = [];

  int get listenerCount => _listener.length;
  static final _logger = Logger();
  static IO.Socket? _socket;
  set socket(IO.Socket? socket) {
    _socket ??= socket;
  }

  void _runner(Function() callback) {
    Future.delayed(const Duration(milliseconds: 1000), callback);
  }

  void _init() {
    _socket?.onConnectTimeout((data) {
      _logger.e("ConnectTimeout $data");
    });
    _socket?.onError((data) {
      _logger.e("onErrr $data");
    });
    _socket?.onConnectError((data) {
      _logger.e("onConnectError $data");
    });
    _socket?.onConnect((data) {
      _logger.i("Connected");
    });
    _socket?.onConnecting((data) {
      _logger.i("Connecting");
    });
    _socket?.on("connection", (data) {
      _logger.i("Connect Msg : $data");
    });
  }

  final AuthService _auth = Locator<AuthService>();
  Future<void> init() async {
    if (_socket != null) {
      dispose();
    }

    final token = await _auth.currentuser?.getIdToken();
    socket = IO.io(
      BASE_URL,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .enableAutoConnect()
          .build(),
    );
    _init();
  }

  void listen(String event, Function(dynamic) callback) {
    _logger.i("this is listen");
    _logger.i(event);
    _logger.i(_listener);
    _logger.i("socket ${_socket?.connected}");
    if (_socket == null) {
      return _runner(() => listen(event, callback));
    }
    if (_socket?.connected != true) {
      return _runner(() => listen(event, callback));
    }
    if (_listener.contains(event)) return;
    _listener.add(event);
    _socket?.on(event, callback);
  }

  void emit(String event, dynamic data) {
    if (_socket == null) {
      return _runner(() => emit(event, data));
    }
    if (_socket?.connected != true) {
      return _runner(() => emit(event, data));
    }
    Future.delayed(
      const Duration(seconds: 2),
      () => _socket?.emit(event, data),
    );
  }

  // LiveStreamUtilService(this.socket) {
  //   init();
  // }
  void dispose() {
    _socket?.dispose();
    socket = null;
  }
}
