import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/models/post.dart';
import 'package:live_streaming/posts/post_event.dart';
import 'package:live_streaming/posts/post_state.dart';
import 'package:live_streaming/service/post/post_service.dart';
import 'package:logger/logger.dart';

class PostBloc extends Bloc<PostBaseEvent, PostBaseState> {
  final PostService _postService = Locator<PostService>();

  static final Logger _logger = Logger();

  PostBloc() : super(const PostInitialState()) {
    _logger.i("this is postbloc");
    on<PostNextPageEvent>((_, emit) async {
      if (state is PostLoadingState) return;
      final List<Post> copied = state.posts.toList();
      _logger.i("this is postbloc ${copied.length}");
      _logger.i("this is copied ${copied.length}");
      if (copied.isEmpty) {
        emit(PostLoadingState(copied));
      } else {
        emit(PostSoftLoadingState(copied));
      }
      final Result<List<Post>> result = await _postService.getAllPost();
      if (result.hasError) {
        _logger.w(result.error?.messsage);
        _logger.e(result.error?.stackTrace);
        emit(PostErrorState(copied, result.error?.messsage));
        return;
      }
      _logger.i("this is copied ${copied.map((e) => e.content.toString())}");
      copied.addAll(result.data);
      emit(PostSuccesState(copied));
    });

    add(const PostNextPageEvent());
  }
}
