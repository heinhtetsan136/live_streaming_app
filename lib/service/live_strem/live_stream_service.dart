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

class LiveStreamUtilService {
  static final _logger = Logger();
  late final IO.Socket? socket;
  void init() {
    socket?.onConnect((data) => _logger.i("on connect $data"));
    socket?.onerror((data) {
      _logger.e("errror $data");
    });
    socket?.onConnectError((data) => _logger.e("on connect error $data"));
  }

  final AuthService _auth = Locator<AuthService>();
  Future<void> setup() async {
    if (socket != null) return;

    final token = await _auth.currentuser?.getIdToken();
    IO.io(BASE_URL, {
      "transport": ["websocket", "polling"],
      "header": {
        "Autherization": "Bearer $token",
      }
    });
    init();
  }

  // LiveStreamUtilService(this.socket) {
  //   init();
  // }
  void dispose() {
    socket?.destroy();
  }
}

abstract class LiveStreamBaseService extends LiveStreamUtilService {
  LiveStreamBaseService();
  final Dio dio = Locator<Dio>();
  final AuthService authService = Locator<AuthService>();
}

class LiveStreamService extends LiveStreamBaseService {
  LiveStreamService._() : super();
  static LiveStreamService instance() {
    return LiveStreamService._();
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
}
