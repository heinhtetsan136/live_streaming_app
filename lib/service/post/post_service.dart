import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_streaming/core/error/error.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/models/post.dart';
import 'package:live_streaming/service/auth_service.dart/auth_sevice.dart';
import 'package:live_streaming/util/const/post_base_url.dart';

class PostResult {
  final List<Post> post;
  final int? nextPage;

  PostResult(this.post, [this.nextPage]);
}

class PostService {
  final AuthService _authService = Locator<AuthService>();
  final Dio _dio;
  PostService({
    int page = 1,
    int limit = 20,
  })  : _dio = Locator<Dio>(),
        _page = page,
        _limit = limit;
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
      final response = await _dio.get("$POST_BASE_URL?page=$page&limit=$_limit",
          options: Options(headers: {
            "Authorization": "Bearer $token",
          }));
      final body = response.data;
      // print(body);
      _hasnextpage = body['next_page'] != null;
      print(_hasnextpage);
      final post = (body["data"] as List).map(Post.fromJson).toList();
      print(post);
      if (_hasnextpage) {
        return Result(data: PostResult(post, page + 1));
      }

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

      final i = result.data.nextPage;
      print(i);
      if (i != null && _page > i) {
        page = i;
      } else {
        page = null;
      }
      posts.addAll(result.data.post);
    }
    print(posts.length);

    return Result(data: posts);
  }
}
