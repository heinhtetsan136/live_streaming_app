import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_streaming/core/error/error.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:live_streaming/service/live_strem/live_stream_base_service.dart';
import 'package:live_streaming/service/live_strem/model.dart';
import 'package:live_streaming/util/const/post_base_url.dart';
import 'package:logger/logger.dart';

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
  // void setViewerCount(int count){
  //   super.emit("event", data)
  // }

  void startLiveStream(int liveId) {
    _logger.i("emit host event");
    super.emit("host", "$liveId");
  }

  void _listenliveEvent() {
    super.listen("viewCount", ((p0) {
      super.setViewCount(int.parse(p0.toString()));
    }));
    super.listen("join", ((p0) {
      _logger.i(p0.toString());
    }));
    super.listen("LiveComment", ((p0) {
      setComment(p0.toString());
    }));
  }

  @override
  void dispose() {
    // _stream.close();
    // TODO: implement dispose
    super.dispose();
  }
}
