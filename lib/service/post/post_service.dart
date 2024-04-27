import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_streaming/core/error/error.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/models/post.dart';
import 'package:live_streaming/service/auth_service.dart/auth_sevice.dart';
import 'package:live_streaming/service/ui_live_strem/socket_util_service.dart';
import 'package:live_streaming/util/const/post_base_url.dart';

class PostResult<T> {
  final List<T> post;
  final int? nextPage;

  PostResult(this.post, [this.nextPage]);
}

abstract class ApiBaseService<T> extends LiveStreamUtilService {
  String get baseUrl;
  T parser(dynamic data);
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
  bool postpredicate(int postOwner, int? socketId);
  void postlistener(void Function(Post post) callback) {
    listen("post", (p0) {
      try {
        final post = Post.fromJson(p0);
        if (postpredicate(post.userId, socketId)) callback(post);
      } catch (e) {}
    });
  }

  int _page;
  final int _limit;
  bool _hasnextpage = true;
  Future<Result<PostResult<T>>> fetchPost(int page) async {
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
      final post = (body['data'] as List).map(parser).toList();
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
  Future<Result<List<T>>> getAllPost() async {
    if (!_hasnextpage && _trycount < 2) {
      _trycount += 1;
      return Result(error: GeneralError("NO More Post"));
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
    return Result<List<T>>(
      data: result.data.post,
    );
  }

  Future<Result<List<T>>> refresh() async {
    final List<T> posts = [];
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
    }
    // print("this is post length ${posts.toString()}");

    return Result(
      data: posts,
    );
  }
}

class PostService extends ApiBaseService<Post> {
  @override
  bool postpredicate(int postOwner, int? socketId) {
    // TODO: implement postpredicate
    return postOwner != socketId;
  }

  @override
  // TODO: implement baseUrl
  String get baseUrl => POST_BASE_URL;

  @override
  Post parser(data) {
    return Post.fromJson(data);
    // TODO: implement parser
  }
}

class MyPostService extends ApiBaseService<Post> {
  @override
  bool postpredicate(int postOwner, int? socketId) {
    // TODO: implement postpredicate
    return postOwner == socketId;
  }

  @override
  // TODO: implement baseUrl
  String get baseUrl => MY_POST_BASE_URL;

  @override
  Post parser(data) {
    return Post.fromJson(data);
    // TODO: implement parser
  }
}

class SearchPostService extends ApiBaseService<Post> {
  String search = "";

  @override
  // TODO: implement baseUrl
  String get baseUrl => "${Search_POST_BASE_URL}search";

  @override
  Post parser(data) {
    // TODO: implement parser
    return Post.fromJson(data);
  }

  @override
  bool postpredicate(int postOwner, int? socketId) {
    // TODO: implement postpredicate
    return postOwner == socketId;
  }
}
