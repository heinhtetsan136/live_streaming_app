import 'package:equatable/equatable.dart';
import 'package:live_streaming/models/post.dart';

///GET
abstract class PostBaseState extends Equatable {
  final List<Post> posts;
  const PostBaseState(this.posts);
  @override
  // TODO: implement props
  List<Object?> get props => posts;
}

class PostInitialState extends PostBaseState {
  const PostInitialState() : super(const []);
}

class PostLoadingState extends PostBaseState {
  const PostLoadingState(super.posts);
}

class PostSoftLoadingState extends PostBaseState {
  const PostSoftLoadingState(super.posts);
}

class PostSuccesState extends PostBaseState {
  const PostSuccesState(super.posts);
}

class PostErrorState extends PostBaseState {
  final String? message;
  const PostErrorState(super.posts, this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [...posts, message];
}
