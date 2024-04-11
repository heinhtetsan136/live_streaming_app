class UiLiveStreamComment {
  final int id, liveId, userId;
  final String comment, identity, displayName, profilePhoto;
  final DateTime createdAt;

  UiLiveStreamComment(
      {required this.id,
      required this.liveId,
      required this.userId,
      required this.comment,
      required this.identity,
      required this.displayName,
      required this.profilePhoto,
      required this.createdAt});
  factory UiLiveStreamComment.fromJson(dynamic data) {
    final user = data['user'];
    return UiLiveStreamComment(
      id: int.parse(data['id'].toString()),
      //data['id'] as int
      liveId: int.parse(data['live_id'].toString()),
      userId: int.parse(user['Uid'].toString()),
      comment: data['comment'],
      identity: user['Identifier'],
      displayName: user['DisplayName'],
      profilePhoto: user['ProfilePhoto'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }
}
