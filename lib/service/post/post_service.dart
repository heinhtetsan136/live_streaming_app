import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_streaming/core/error/error.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/models/post.dart';
import 'package:live_streaming/service/auth_sevice.dart';
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
      print("token is $token");
      final response = await _dio.get("$POST_BASE_URL?page=$page&limit=$_limit",
          options: Options(headers: {
            "Authorization": "Bearer $token",
          }));
      final body = response.data;
      _hasnextpage = body["next page"] != null;
      final post = (body["data"] as List).map(Post.fromJson).toList();
      if (_hasnextpage) {
        return Result(data: PostResult(post, page += 1));
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

  Future<Result<List<Post>>> getAllPost() async {
    if (!_hasnextpage) return Result(data: []);
    final result = await fetchPost(_page);
    if (result.error != null) {
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

    int? page = 1;

    while (page != null) {
      final result = await fetchPost(page);
      if (result.error != null) {
        return Result(error: GeneralError(result.error!.messsage.toString()));
      }
      final i = result.data.nextPage;
      if (i != null && _page > i) {
        page = i;
      } else {
        page = null;
      }
      posts.addAll(result.data.post);
    }

    return Result(data: posts);
  }
}
