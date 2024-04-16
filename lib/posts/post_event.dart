import 'package:live_streaming/models/post.dart';

abstract class PostBaseEvent {
  const PostBaseEvent();
}

class PostNextPageEvent extends PostBaseEvent {
  const PostNextPageEvent();
}

class NewPostEvent extends PostBaseEvent {
  final DateTime createdAt = DateTime.now();
  final List<Post> post;
  NewPostEvent(this.post);
}

class RefreshEvent extends PostBaseEvent {
  const RefreshEvent();
}
// class PostRefreshEvent extends PostBaseEvent {
//   const PostRefreshEvent();
// }
