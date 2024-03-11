import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

Future requestPermission() async {
  final List<Permission> requiredPermission = [];
  if (!(await Permission.camera.isGranted)) {
    requiredPermission.add(Permission.camera);
  }
  if (!(await Permission.microphone.isGranted)) {
    requiredPermission.add(Permission.microphone);
  }
  if (requiredPermission.isNotEmpty) {
    requiredPermission.request();
    return requestPermission();
  }
}

// ignore: non_constant_identifier_names
class AgoraHandler {
  final void Function(RtcConnection connection, int remoteUid, int elapsed)
      onUserJoined;
  final void Function(RtcConnection connection, int elapsed)
      onJoinChannelSuccess;
  final void Function(
          RtcConnection connection, int remoteUid, UserOfflineReasonType reason)
      onUserOffline;
  final void Function(RtcConnection connection, String token)
      onTokenPrivilegeWillExpire;
  final void Function(RtcConnection connection, int elapsed)?
      onRejoinChannelSuccess;
  final void Function(RtcConnection connection, RtcStats stats) onLeaveChannel;

  final void Function(ErrorCodeType err, String msg)? onError;
  AgoraHandler({
    required this.onError,
    required this.onLeaveChannel,
    required this.onUserJoined,
    required this.onUserOffline,
    required this.onJoinChannelSuccess,
    required this.onTokenPrivilegeWillExpire,
    required this.onRejoinChannelSuccess,
  });
  factory AgoraHandler.fast() {
    return AgoraHandler(
        onError: (_, __) {},
        onLeaveChannel: (_, __) {},
        onUserJoined: (_, __, ___) {},
        onUserOffline: (_, __, ___) {},
        onJoinChannelSuccess: (_, __) {},
        onTokenPrivilegeWillExpire: (_, __) {},
        onRejoinChannelSuccess: (_, __) {});
  }
}

const _waiting = 0;

abstract class AgoraBaseService {
  final Logger _logger;
  late final RtcEngine engine;
  AgoraBaseService() : _logger = Logger() {
    engine = createAgoraRtcEngine();
  }

  int _state = _waiting;
  int get status => _state;
  // Future<void> host() {
  //   return engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
  // }

  // Future<void> Guest() {
  //   return engine.setClientRole(role: ClientRoleType.clientRoleAudience);
  // }
  ClientRoleType get clientRole;
  Future<void> ready() async {
    assert(status == 1);

    _logger.i("Ready");
    engine.registerEventHandler(_handler);
    await engine.setClientRole(role: clientRole);
    await engine.enableVideo();
    await engine.enableAudio();
    _state = 2;
  }

  Future<void> live(String token, String channelId,
      [int? uid, ChannelMediaOptions? options]) async {
    assert(status == 2);
    await engine.joinChannel(
        token: token,
        channelId: channelId,
        uid: uid ?? 0,
        options: options ?? const ChannelMediaOptions());
  }

  String get appid => "e8c618eaf31d45728bc22f12d62c8c02";
  VideoViewController get controller;
  ChannelProfileType get channelprofile =>
      ChannelProfileType.channelProfileLiveBroadcasting;
  Future<void> init() async {
    assert(status == 0);
    print("init state");
    _logger.i("ini");
    await requestPermission();
    await engine.initialize(RtcEngineContext(
        appId: appid,
        channelProfile: channelprofile,
        logConfig: const LogConfig(level: LogLevel.logLevelFatal)));
    _state = 1;
  }

  RtcConnection? connection;
  late final RtcEngineEventHandler _handler;
  StreamController<RtcConnection> onLive =
      StreamController<RtcConnection>.broadcast();
  set handler(AgoraHandler h) {
    _handler = RtcEngineEventHandler(onError: ((err, msg) {
      h.onError!(err, msg);
      _logger.e(" [Stream:On Error] [error] $err/n [str] $msg");
    }), onUserJoined: (con, remoteuid, _) {
      _logger.i("[Stream:On User Joined] [onuserjoined]$remoteuid");
      //To Do
      connection = con;
      onLive.sink.add(con);
      h.onUserJoined(con, remoteuid, _);
    }, onUserOffline: (con, uid, reason) {
      _logger.i("[Stream:onuseroffline] [onuseroffline]$uid $con $reason");
      //To Do
      h.onUserOffline(con, uid, reason);
    }, onRejoinChannelSuccess: (connection, _) {
      h.onJoinChannelSuccess(connection, _);

      _logger.i("[onrejoin] [onrejoin]$connection");
    }, onLeaveChannel: (conn, status) {
      h.onLeaveChannel(conn, status);
      _logger.i("[Stream:onleave] [onleave]$conn $status ");
    }, onJoinChannelSuccess: (connection, uId) {
      onLive.sink.add(connection);
      _logger.i(
          "[Stream:onjoinchannelsucess] [onjoinchannelsucess]$uId [conntection]$connection");
      h.onJoinChannelSuccess(connection, uId);
    }, onTokenPrivilegeWillExpire: (conn, token) {
      _logger.d("[Stream:ontolkeprivil] [:ontolkeprivil]$token $conn");
      print("RTC onTokeExpire $token");
      h.onTokenPrivilegeWillExpire(conn, token);
    });
  }

  Future<void> dispose() async {
    assert(status == 1);
    engine.unregisterEventHandler(_handler);
    await engine.leaveChannel();
    await engine.release();
  }
}
