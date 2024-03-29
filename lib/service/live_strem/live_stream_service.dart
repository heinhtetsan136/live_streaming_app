import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_streaming/core/error/error.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/service/auth_sevice.dart';
import 'package:live_streaming/service/live_strem/model.dart';
import 'package:live_streaming/util/const/post_base_url.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class LiveStreamUtilService {
  final StreamController<bool> _stream = StreamController.broadcast();
  final StreamController _userJoin = StreamController.broadcast();
  final StreamController<List> _comments = StreamController.broadcast();
  final StreamController<int> _viewCount = StreamController.broadcast();
  Stream<bool> get stream => _stream.stream;
  Stream<int> get viewcount => _viewCount.stream;
  Stream<List> get comment => _comments.stream;
  Stream get userjoin => _userJoin.stream;
  void setLiveStreamStatus(bool status) {
    _stream.sink.add(status);
  }

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

abstract class LiveStreamBaseService extends LiveStreamUtilService {
  LiveStreamBaseService();
  final Dio dio = Locator<Dio>();
  final AuthService authService = Locator<AuthService>();
}

class LiveStreamHostService extends LiveStreamBaseService {
  LiveStreamHostService() {
    _logger.i("this is host");
    super.init();
    super.listen("hostEvent", (p0) {
      _logger.i("host event");
      final isStarted = int.parse(p0.toString()) == 200;
      _listenliveEvent();
      setLiveStreamStatus(isStarted);
    });
  }

  static final _logger = Logger();
  Future<Result<LivePayload>> postCreate(String content) async {
    try {
      final String? token = await authService.currentuser?.getIdToken();
      if (token == null) {
        return Result(error: GeneralError("Unauthorized"));
      }
      final response = await dio.post(
        POST_BASE_URL,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
        data: FormData.fromMap({"content": content}),
      );
      _logger.i(response.data);
      return Result(data: LivePayload.fromJson(response.data));
    } on DioException catch (e) {
      return Result(
        error: GeneralError(
          e.response?.data.toString() ?? e.message ?? e.toString(),
          e.stackTrace,
        ),
      );
    } on SocketException catch (e) {
      return Result(error: GeneralError(e.message));
    } catch (e) {
      return Result(error: GeneralError(e.toString()));
    }
  }

  void startLiveStream(int liveId) {
    _logger.i("emit host event");
    super.emit("host", "$liveId");
  }

  void _listenliveEvent() {}

  @override
  void dispose() {
    _stream.close();
    // TODO: implement dispose
    super.dispose();
  }
}
