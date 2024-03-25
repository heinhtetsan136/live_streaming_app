import 'package:live_streaming/models/post.dart';

abstract class PostBaseState {
  final List<Post> post;
  const PostBaseState(this.post);
}

class PostInitialState extends PostBaseState {
  PostInitialState() : super([]);
}

class PostLoadingState extends PostBaseState {
  const PostLoadingState(super.post);
}

class PostSoftLoadingState extends PostBaseState {
  const PostSoftLoadingState(super.post);
}

class PostSucessState extends PostBaseState {
  const PostSucessState(super.post);
}

class PostErrorState extends PostBaseState {
  final String? message;
  const PostErrorState(super.post, this.message);
}
