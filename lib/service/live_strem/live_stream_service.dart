import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_streaming/core/error/error.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/service/auth_sevice.dart';

import 'package:live_streaming/service/live_strem/model.dart';
import 'package:live_streaming/util/const/post_base_url.dart';
import 'package:logger/logger.dart';

abstract class LiveStreamBaseService {
  final Dio dio = Locator<Dio>();
  final AuthService authService = Locator<AuthService>();
}

class LiveStreamHostService extends LiveStreamBaseService {
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
