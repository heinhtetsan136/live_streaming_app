// class LiveStreamGuestService extends LiveStreamBaseService{

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_streaming/core/error/error.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:live_streaming/service/ui_live_strem/base/live_stream_base_service.dart';
import 'package:live_streaming/util/const/post_base_url.dart';
import 'package:logger/logger.dart';

class LiveStreamGuestService extends LiveStreamBaseService {
  static final _logger = Logger();
  LiveStreamGuestService() {
    init();
    super.listen("joinEvent", (p0) {
      final isJoined = int.parse(p0.toString()) == 200;
      _logger.i("this is guest ui $isJoined");
      if (isJoined) {
        _listener();
        setLiveStreamStatus(true);

        return;
      }
      setLiveStreamStatus(false);
      comsumeLiveEvent();
    });
  }
  void _listener() {
    comsumeLiveEvent();
  }

  Future<Result<dynamic>> generateToken(int liveId, String channel) async {
    try {
      final token = await authService.currentuser?.getIdToken();
      if (token == null) {
        return Result(error: GeneralError("Unauthorized"));
      }
      final response = await dio.post("$POST_BASE_URL/$liveId/join",
          options: Options(headers: {
            "Authorization": 'Bearer $token',
          }),
          data: FormData.fromMap({
            'channel': channel,
          }));
      if ((response.statusCode ?? 500) > 300) {
        return Result(
            error: GeneralError(
                response.statusMessage ?? response.data ?? "unknownerror"));
      }
      return Result(data: response.data);
    } on DioException catch (e) {
      return Result(
          error: GeneralError(
              e.response?.data["error"].toString() ?? e.message.toString()));
    } on SocketException catch (e) {
      return Result(error: GeneralError(e.message));
    } catch (e) {
      return Result(error: GeneralError(e.toString()));
    }
  }

  void join(int liveId) {
    super.emit("join", "$liveId");
  }
}
