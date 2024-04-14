import 'package:live_streaming/locator.dart';
import 'package:live_streaming/service/auth_service.dart/auth_sevice.dart';
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

  Future<bool> get isSocketReady {
    return _validate(() async {
      return true;
    }, () {
      print("_socket ${_socket?.connected.toString()}");
      if (_socket?.connected != true) {
        print("_socket ${_socket?.connected.toString()}");
        _socket?.disconnect();
        _socket?.connect();
      }
      return isSocketReady;
    });
  }

  int _interval = 500;

  int _failCount = 0;
  Future<T> _runner<T>(Future<T> Function() callback) async {
    return Future.delayed(Duration(milliseconds: _interval), callback);
  }

  Future<T> _validate<T>(Future<T> Function() run, Future<T> Function() fail) {
    if (_failCount > 3) {
      _interval += _interval;
      _failCount = 0;
      return _runner(fail);
    }

    _logger.i("this is listen");
    // _logger.i(event);
    _logger.i(_listener);
    _logger.i("socket ${_socket?.connected}");
    if (_socket == null) {
      _failCount++;
      return _runner(fail);
    }
    if (_socket?.connected != true) {
      _failCount++;
      return _runner(fail);
    }
    _failCount = 0;
    _interval = 500;
    return run();
  }

  void _defaultEvent() {
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
      destory();
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
    _defaultEvent();
  }

  void listen(String event, Function(dynamic) callback) {
    _validate(() async {
      _listener.add(event);
      _socket?.on(event, callback);
    }, () async => listen(event, callback));
  }

  void emit(String event, dynamic data) {
    _validate(() async {
      Future.delayed(
        const Duration(seconds: 2),
        () => _socket?.emit(event, data),
      );
    }, () async => emit(event, data));
  }

  // LiveStreamUtilService(this.socket) {
  //   init();
  // }
  void destory() {
    _socket?.dispose();
    socket = null;
  }
}
