import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/post/post_event.dart';
import 'package:live_streaming/controller/post/post_state.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/models/post.dart';
import 'package:live_streaming/service/post/post_service.dart';
import 'package:logger/logger.dart';

final PostService _postService = Locator<PostService>();

class PostBloc extends Bloc<PostBaseEvent, PostBaseState> {
  static Logger logger = Logger();
  PostBloc() : super(PostInitialState()) {
    on<PostNextPageEvent>(
      (_, emit) async {
        final Result<List<Post>> result = await _postService.getAllPost();
        final copy = state.post.toList();
        if (state is PostLoadingState) return;
        if (copy.isEmpty) {
          emit(PostLoadingState(copy));
        } else {
          emit(PostSoftLoadingState(copy));
        }

        if (result.hasError) {
          logger.e("error is${result.error?.messsage.toString()}");
          logger.i(result.error?.stackTrace);
          emit(PostErrorState(copy, result.error?.messsage.toString()));
          return;
        }
        copy.addAll(result.data);
        emit(PostSucessState(copy));
      },
    );
    add(const PostNextPageEvent());
  }
}
