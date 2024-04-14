import 'package:flutter/cupertino.dart';
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
  final ScrollController scrollController = ScrollController();

  PostBloc() : super(const PostInitialState()) {
    scrollController.addListener(() {
      final max = scrollController.position.maxScrollExtent;
      final current = scrollController.position.pixels;
      if (max / current > 0.8) {
        add(const PostNextPageEvent());
      }
    });

    _postService.postlistener((post) {
      final copied = state.posts;
      final index = copied.indexOf(post);
      if (index == -1) {
        ///new post
        copied.add(post);
      } else {
        copied[index] = post;
      }

      // copied.insert(0, post);
      add(NewPostEvent(copied.reversed.toList()));
      // emit(PostSu
    });

    _logger.i("this is postbloc");
    on<NewPostEvent>((event, emit) {
      print("new post ${event.post..map((e) => e.content).toString()}");
      emit(PostSuccesState(event.post));
    });
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
  @override
  Future<void> close() {
    scrollController.dispose();
    _postService.destory();
    // TODO: implement close
    return super.close();
  }
}
