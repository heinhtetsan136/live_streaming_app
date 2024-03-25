import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id, userId, liveId, likeCount, commentCount, viewCount;
  final String content, channel, status, displayName, profilePhoto;
  final String? token;
  final DateTime createdAt;

  const Post({
    required this.id,
    required this.userId,
    required this.liveId,
    required this.likeCount,
    required this.commentCount,
    required this.viewCount,
    required this.content,
    required this.channel,
    required this.token,
    required this.status,
    required this.displayName,
    required this.profilePhoto,
    required this.createdAt,
  });

  factory Post.fromJson(dynamic data) {
    return Post(
      id: int.parse(data['id'].toString()),
      userId: int.parse(data['UserID'].toString()),
      liveId: int.parse(data['live']['id'].toString()),
      likeCount: int.parse(data['live']['like_count'].toString()),
      commentCount: int.parse(data['live']['comment_count'].toString()),
      viewCount: int.parse(data['live']['viewer_count'].toString()),
      content: data['content'],
      channel: data['live']['channel'],
      token: data['live']['token'],
      status: data['live']['Status'],
      displayName: data['user']['DisplayName'],
      profilePhoto: data['user']['ProfilePhoto'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }

  @override
  List<Object?> get props => [id];
}
