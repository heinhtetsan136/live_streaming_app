import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_streaming/core/error/error.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/service/auth_service.dart/auth_sevice.dart';
import 'package:live_streaming/service/ui_live_strem/model/ui_livecomment.dart';
import 'package:live_streaming/service/ui_live_strem/socket_util_service.dart';
import 'package:live_streaming/util/const/post_base_url.dart';
import 'package:logger/logger.dart';

abstract class LiveStreamBaseService extends LiveStreamUtilService {
  final Dio dio = Locator<Dio>();
  static final _logger = Logger();
  final AuthService authService = Locator<AuthService>();
  final StreamController<bool?> _stream = StreamController.broadcast();
  final StreamController _userJoin = StreamController.broadcast();
  final StreamController<List<UiLiveStreamComment>> _comment =
      StreamController.broadcast();
  final StreamController<int> _viewCount = StreamController.broadcast();
  Stream<bool?> get stream {
    Future.delayed(const Duration(milliseconds: 500),
        () => setLiveStreamStatus(_setliveStream));
    return _stream.stream;
  }

  Stream<int> get viewcount {
    Future.delayed(
        const Duration(milliseconds: 500), () => setViewCount(_lastCount));
    return _viewCount.stream;
  }

  Stream<List<UiLiveStreamComment>> get comment {
    Future.delayed(
        const Duration(milliseconds: 200), () => setComment(_usercomments));
    return _comment.stream;
  }

  Stream get userjoin => _userJoin.stream;
  int _lastCount = 0;
  void setViewCount(int count) {
    _lastCount = count;
    _viewCount.sink.add(_lastCount);
  }

  final List<UiLiveStreamComment> _usercomments = [];
  void setComment(dynamic comment) {
    _logger.i("commecnt ingusesctc  ${comment.toString()}");
    if (comment is List<UiLiveStreamComment>) {
      _comment.sink.add(_usercomments);
      return;
    }
    _usercomments.add(UiLiveStreamComment.fromJson(comment));
    _usercomments.sort((p, c) => c.createdAt.compareTo(p.createdAt));
    _logger.i("list comment ${_usercomments.toString()}");
    _comment.sink.add(_usercomments);
  }

  Future<Result> sendcomment(String comment, int liveId) async {
    try {
      final String? token = await authService.currentuser?.getIdToken();
      if (token == null) {
        return Result(error: GeneralError("UnAutherized"));
      }
      final result = await dio.post("$POST_BASE_URL/$liveId/comment",
          options: Options(headers: {
            "Authorization": 'Bearer $token',
          }),
          data: FormData.fromMap({
            "comment": comment,
          }));
      _logger.i("commentsection ${result.data.toString()}");

      return Result(data: null);
    } on SocketException catch (e) {
      return Result(
          error: GeneralError(
        e.message,
      ));
    } on DioException catch (e) {
      return Result(
        error: GeneralError(e.message.toString(), e.stackTrace),
      );
    } catch (e) {
      return Result(error: GeneralError(e.toString()));
    }
  }

  bool? _setliveStream;
  void setLiveStreamStatus(bool? status) {
    _setliveStream = status;
    _stream.sink.add(_setliveStream);
    // LiveStreamBaseService();
  }

  void comsumeLiveEvent() {
    listen("viewCount", ((p0) {
      setViewCount(int.parse(p0.toString()));
      _logger.i("this is livecc ${p0.toString()}");
      // super.set
    }));
    listen("liveComment", setComment);
  }

  @override
  void dispose() {
    _viewCount.close();
    _comment.close();
    _userJoin.close();
    _stream.close();
    // TODO: implement dispose
    super.dispose();
  }
}
