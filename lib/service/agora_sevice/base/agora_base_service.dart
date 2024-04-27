import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/service/frebase/firestore.dart';
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

class AgoraLiveConnection {
  final RtcConnection connection;
  final int remoteId;

  AgoraLiveConnection({required this.connection, required this.remoteId});
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
  final void Function(RtcConnection connection, int elapsed)
      onRejoinChannelSuccess;
  final void Function(RtcConnection connection, RtcStats stats) onLeaveChannel;

  final void Function(ErrorCodeType err, String msg) onError;
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
      onJoinChannelSuccess: (_, __) {},
      onUserJoined: (_, __, ___) {},
      onUserOffline: (_, __, ___) {},
      onTokenPrivilegeWillExpire: (_, __) {},
      onRejoinChannelSuccess: (_, __) {},
      onLeaveChannel: (_, __) {},
      onError: (_, __) {},
    );
  }
}

const _waiting = 0;

abstract class AgoraBaseService {
  final SettingService settingService;
  // static Logger logger = Logger();
  final RtcEngine engine;
  AgoraBaseService()
      : engine = createAgoraRtcEngine(),
        settingService = Locator<SettingService>();

  int _state = 0;
  int get status => _state;
  bool _withSound = true;
  final StreamController<bool> _audioStream = StreamController();
  Stream<bool> get audioStream => _audioStream.stream;
  // Future<void> host() {
  //   return engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
  // }

  // Future<void> Guest() {
  //   return engine.setClientRole(role: ClientRoleType.clientRoleAudience);
  // }
  ClientRoleType get clientRole;
  Future<void> ready() async {
    assert(status == 1 || _handler != null);
    _state = 2;
    // logger.i("Ready");
    engine.registerEventHandler(_handler!);
    await engine.setClientRole(role: clientRole);
    await engine.enableAudio();
    if (clientRole == ClientRoleType.clientRoleAudience) {
      final setting = await settingService.Read();
      _withSound = setting.isSound;
      await _audio();
    }

    // logger.i(status);
  }

  Future<void> _audio() async {
    _audioStream.sink.add(_withSound);
    if (_withSound) {
      await engine.enableAudio();
    }
    await engine.disableAudio();
  }

  Future<void> audioToggle() async {
    _withSound != _withSound;
    await _audio();
  }

  String? channel;
  int? uid;
  String? token;
  Future<void> live(String token, String channel,
      [int? uid, ChannelMediaOptions? options]) async {
    this.uid = uid!;
    this.token = token;
    assert(status == 2);
    // logger.i("Live");
    this.channel = channel;
    await engine.joinChannel(
        token: token,
        channelId: channel,
        uid: uid ?? 0,
        options: options ?? const ChannelMediaOptions());
  }

  String get appid => "e8c618eaf31d45728bc22f12d62c8c02";
  VideoViewController get videoViewcontroller;
  ChannelProfileType get channelprofile =>
      ChannelProfileType.channelProfileLiveBroadcasting;
  Future<void> init() async {
    print("assert $status");
    assert(status == 0);
    print("init state");
    // logger.i("ini");
    await requestPermission();
    await engine.initialize(RtcEngineContext(
        appId: appid,
        channelProfile: channelprofile,
        logConfig: const LogConfig(level: LogLevel.logLevelFatal)));
    _state = 1;
  }

  AgoraLiveConnection? connection;
  RtcEngineEventHandler? _handler;

  StreamController<AgoraLiveConnection?> onLive =
      StreamController<AgoraLiveConnection?>.broadcast();
  set handler(AgoraHandler h) {
    _handler = RtcEngineEventHandler(
      //Live Start
      onUserJoined: (conn, remoteUid, _) {
        // logger.i("[stream:onUserJoined] [conn] $conn\n[remoteUid] $remoteUid");
        connection = AgoraLiveConnection(connection: conn, remoteId: remoteUid);
        onLive.sink.add(connection);
        h.onUserJoined(conn, remoteUid, _);
      },
      //Live Stop

      onUserOffline: (conn, uid, reason) {
        // logger.d(
        //     "[stream:onUserOffline] [conn] $conn\n[uid] $uid\n[reason] $reason");
        h.onUserOffline(conn, uid, reason);
      },
      //Live Stop

      onTokenPrivilegeWillExpire: (conn, token) {
        // logger.d(
        //     "[stream:onTokenPrivilegeWillExpire] [conn] $conn\n[token] $token");
        h.onTokenPrivilegeWillExpire(conn, token);
      },

      ///View Count ++
      onJoinChannelSuccess: (conn, uid) {
        // logger.i("[stream:onJoinChannelSuccess] [conn] $conn\n[uid] $uid");
        h.onJoinChannelSuccess(conn, uid);
      },

      ///View Count ++
      onRejoinChannelSuccess: (conn, _) {
        // logger.i("[stream:onRejoinChannelSuccess] [conn] $conn");
        h.onRejoinChannelSuccess(conn, _);
      },

      ///View Count --
      onLeaveChannel: (conn, stats) {
        // logger.i("[stream:onLeaveChannel] [conn] $conn\n[stats] $status");
        h.onLeaveChannel(conn, stats);
      },

      ///Ui
      onError: (code, str) {
        // logger.e("[stream:onError] [code] $code\n[str] $str");
        h.onError(code, str);
      },
    );
  }

  Future<void> close() async {
    assert(status > 0);
    _state = 0;
    _withSound = true;
    engine.unregisterEventHandler(_handler!);
    await engine.leaveChannel();
    await engine.release();
  }

  Future<void> dispose() async {
    _audioStream.close();
  }
}
