import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_streaming/core/error/error.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/models/post.dart';
import 'package:live_streaming/service/auth_service.dart/auth_sevice.dart';
import 'package:live_streaming/service/ui_live_strem/socket_util_service.dart';
import 'package:live_streaming/util/const/post_base_url.dart';

class PostResult {
  final List<Post> post;
  final int? nextPage;

  PostResult(this.post, [this.nextPage]);
}

abstract class ApiBaseService extends LiveStreamUtilService {
  String get baseUrl;
  final AuthService _authService = Locator<AuthService>();
  final Dio _dio;
  ApiBaseService({
    int page = 1,
    int limit = 20,
  })  : _page = page,
        _limit = limit,
        _dio = Locator<Dio>() {
    init();
  }
  void postlistener(void Function(Post post) callback) {
    listen("post", (p0) {
      try {
        final post = Post.fromJson(p0);
        if (post.userId == socketId) return;
        callback(Post.fromJson(p0));
      } catch (e) {}
    });
  }

  int _page;
  final int _limit;
  bool _hasnextpage = true;
  Future<Result<PostResult>> fetchPost(int page) async {
    final user = _authService.currentuser;
    if (user == null) {
      return Result(error: GeneralError("Unauthorized"));
    }
    try {
      final String? token = await user.getIdToken();
      if (token == null) {
        return Result(error: GeneralError("Unauthorized"));
      }
      print("token is $token");
      final response = await _dio.get("$baseUrl?page=$page&limit=$_limit",
          options: Options(headers: {
            "Authorization": "Bearer $token",
          }));
      final body = response.data;
      // print(body);

      print("this is next_page ${body['next_page'] != null}");
      final post = (body['data'] as List).map(Post.fromJson).toList();
      print("this is post ${post.length}");
      if (body['next_page'] != null) {
        return Result(data: PostResult(post, page + 1));
      }
      print("this is not next_page");
      return Result(data: PostResult(post));
    } on DioException catch (e) {
      return Result(error: GeneralError(e.toString()));
    } on SocketException catch (e) {
      return Result(error: GeneralError(e.message));
    } catch (e) {
      return Result(error: GeneralError(e.toString()));
    }
  }

  int _trycount = 0;
  Future<Result<List<Post>>> getAllPost() async {
    if (!_hasnextpage && _trycount < 2) {
      _trycount += 1;
      return Result(data: []);
    }
    _trycount = 0;
    final result = await fetchPost(_page);
    if (result.hasError) {
      return Result(error: GeneralError(result.error!.messsage.toString()));
    }
    if (result.data.nextPage != null) {
      _page = result.data.nextPage!;
    } else {
      _hasnextpage = false;
    }
    return Result(data: result.data.post);
  }

  Future<Result<List<Post>>> refresh() async {
    final List<Post> posts = [];
    print(posts.toString());

    int? page = 1;

    while (page != null) {
      final result = await fetchPost(page);
      print(result.toString());
      if (result.error != null) {
        return Result(error: GeneralError(result.error!.messsage.toString()));
      }
      print("result is ${result.data.post}");

      final i = result.data.nextPage;
      print("i = $i");
      if (i != null && _page > i) {
        page = i;
      } else {
        page = null;
      }
      posts.addAll(result.data.post);
      print("this is post length ${posts.toString()}}");
      print("this is ${posts.map((e) => e.content.toString())}");
    }
    // print("this is post length ${posts.toString()}");
    print("this is while ${posts.map((e) => e.content.toString())}");
    return Result(data: posts);
  }
}

class PostService extends ApiBaseService {
  @override
  // TODO: implement baseUrl
  String get baseUrl => POST_BASE_URL;
}
