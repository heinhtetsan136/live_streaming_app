import 'dart:async';

import 'package:dio/dio.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/service/auth_service.dart/auth_sevice.dart';
import 'package:live_streaming/service/ui_live_strem/live_stream_util_service.dart';

abstract class LiveStreamBaseService extends LiveStreamUtilService {
  final Dio dio = Locator<Dio>();

  final AuthService authService = Locator<AuthService>();
  final StreamController<bool> _stream = StreamController.broadcast();
  final StreamController _userJoin = StreamController.broadcast();
  final StreamController<List> _usercomments = StreamController.broadcast();
  final StreamController<int> _viewCount = StreamController.broadcast();
  Stream<bool> get stream => _stream.stream;
  Stream<int> get viewcount => _viewCount.stream;
  Stream<List> get comment => _usercomments.stream;
  Stream get userjoin => _userJoin.stream;
  void setViewCount(int count) {
    _viewCount.sink.add(count);
  }

  final List _comment = [];
  void setComment(dynamic comment) {
    _usercomments.sink.add(comment);
    _comment.add(comment);
  }

  void setLiveStreamStatus(bool status) {
    _stream.sink.add(status);
    // LiveStreamBaseService();
  }

  void comsumeLiveEvent() {
    super.listen("ViewCount", ((p0) {
      // super.set
    }));
  }

  @override
  void dispose() {
    _viewCount.close();
    _usercomments.close();
    _userJoin.close();
    _stream.close();
    // TODO: implement dispose
    super.dispose();
  }
}
