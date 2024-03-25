import 'package:equatable/equatable.dart';

class LivePayload extends Equatable {
  final int userID, liveID;

  final String channel, token;

  const LivePayload({
    required this.userID,
    required this.liveID,
    required this.channel,
    required this.token,
  });

  factory LivePayload.fromJson(dynamic data) {
    return LivePayload(
      userID: int.parse(data['UserID'].toString()),
      liveID: int.parse(data['live']['id'].toString()),
      channel: data['live']['channel'],
      token: data['live']['token'],
    );
  }

  LivePayload updateToken(int userID, String token) {
    return LivePayload(
      channel: channel,
      userID: userID,
      liveID: liveID,
      token: token,
    );
  }

  @override
  List<Object?> get props => [channel, token];
}
