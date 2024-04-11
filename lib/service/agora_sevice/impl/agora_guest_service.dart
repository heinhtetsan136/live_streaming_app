import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:live_streaming/service/agora_sevice/base/agora_base_service.dart';

class AgoraGuestService extends AgoraBaseService {
  @override
  Future<void> init() async {
    await super.init();
  }

  AgoraGuestService._() : super();
  static AgoraGuestService? _instance;
  static Future<AgoraGuestService> instance() async {
    _instance ??= AgoraGuestService._();
    return _instance!;
  }

  // @override
  // Future<void> ready() async {
  //   await super.ready();

  //   await engine.startPreview();

  //   // TODO: implement ready
  //   // throw UnimplementedError();
  // }

  @override
  // TODO: implement controller
  VideoViewController get videoViewcontroller => VideoViewController.remote(
      rtcEngine: engine,
      canvas: const VideoCanvas(uid: 3318081957),
      connection: RtcConnection(
        channelId: channel,
      ));

  @override
  // TODO: implement clientRole
  ClientRoleType get clientRole => ClientRoleType.clientRoleAudience;

  @override
  Future<void> dispose() async {
    // TODO: implement dispose
    await onLive.close();
    AgoraGuestService._instance == null;
  }
}
