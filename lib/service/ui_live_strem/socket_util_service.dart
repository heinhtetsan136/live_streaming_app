import 'package:live_streaming/locator.dart';
import 'package:live_streaming/service/auth_service.dart/auth_sevice.dart';
import 'package:live_streaming/util/const/post_base_url.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LiveStreamUtilService {
  String get usage => "live";

  final List<String> _listener = [];

  int get listenerCount => _listener.length;
  static final _logger = Logger();
  static final Map<String, IO.Socket?> _socket = {};
  set socket(IO.Socket? socket) {
    _socket[usage] ??= socket;
  }

  IO.Socket? get socket => _socket[usage];
  Future<bool> get isSocketReady {
    return _validate(() async {
      return true;
    }, () {
      print("_socket ${socket?.connected.toString()}");
      if (socket?.connected != true) {
        // print("_socket ${_socket?.connected.toString()}");
        socket?.disconnect();
        socket?.connect();
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
    _logger.i("socket ${socket?.connected}");
    if (socket == null) {
      _failCount++;
      return _runner(fail);
    }
    if (socket?.connected != true) {
      _failCount++;
      return _runner(fail);
    }
    _failCount = 0;
    _interval = 500;
    return run();
  }

  int? socketId;
  void _defaultEvent() {
    socket?.onConnectTimeout((data) {
      _logger.e("ConnectTimeout $data");
    });
    socket?.onError((data) {
      _logger.e("onErrr $data");
    });
    socket?.onConnectError((data) {
      _logger.e("onConnectError $data");
    });
    socket?.onConnect((data) {
      _logger.i("Connected");
    });
    socket?.onConnecting((data) {
      _logger.i("Connecting");
    });
    socket?.on("connection", (data) {
      socketId = int.tryParse(data["id"].toString());
      _logger.i("Connect Msg : $data");
    });
  }

  final AuthService _auth = Locator<AuthService>();
  Future<void> init() async {
    destory();

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
      socket?.on(event, callback);
    }, () async => listen(event, callback));
  }

  void emit(String event, dynamic data) {
    _validate(() async {
      Future.delayed(
        const Duration(seconds: 2),
        () => socket?.emit(event, data),
      );
    }, () async => emit(event, data));
  }

  // LiveStreamUtilService(this.socket) {
  //   init();
  // }
  void destory() {
    socket?.dispose();
    socket = null;
  }
}
