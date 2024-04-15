import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/models/post.dart';
import 'package:live_streaming/posts/post_event.dart';
import 'package:live_streaming/posts/post_state.dart';
import 'package:live_streaming/service/post/post_service.dart';
import 'package:logger/logger.dart';

abstract class PostBaseBloc extends Bloc<PostBaseEvent, PostBaseState> {
  final ApiBaseService<Post> service;

  static final Logger _logger = Logger();
  final ScrollController scrollController = ScrollController();

  PostBaseBloc(this.service) : super(const PostInitialState()) {
    scrollController.addListener(() {
      final max = scrollController.position.maxScrollExtent;
      final current = scrollController.position.pixels;
      if (max / current > 0.8) {
        add(const PostNextPageEvent());
      }
    });

    service.postlistener((post) {
      final copied = state.posts;
      final index = copied.indexOf(post);
      if (index == -1) {
        ///new post
        copied.add(post);
      } else {
        copied[index] = post;
      }
      final sortcopied = copied
        ..sort((p, c) {
          return p.createdAt.compareTo(c.createdAt);
        });
      // copied.insert(0, post);
      add(NewPostEvent(sortcopied.toList()));
      // emit(PostSu
    });

    _logger.i("this is postbloc");
    on<NewPostEvent>((event, emit) {
      print("new post ${event.post..map((e) => e.content).toString()}");
      emit(PostSuccesState(event.post));
    });
    on<PostNextPageEvent>((_, emit) async {
      if (state is PostLoadingState || state is PostSoftLoadingState) return;
      final List<Post> copied = state.posts.toList();
      _logger.i("this is postbloc ${copied.length}");
      _logger.i("this is copied ${copied.length}");
      if (copied.isEmpty) {
        emit(PostLoadingState(copied));
      } else {
        emit(PostSoftLoadingState(copied));
      }
      final Result<List<Post>> result = await service.getAllPost();
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
    service.destory();
    // TODO: implement close
    return super.close();
  }
}

class PostBloc extends PostBaseBloc {
  PostBloc() : super(Locator<PostService>());
}

class MyPostBloc extends PostBaseBloc {
  MyPostBloc() : super(Locator<MyPostService>());
}
