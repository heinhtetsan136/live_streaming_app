import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:live_streaming/service/agora_sevice/base/agora_base_service.dart';

class AgoraHostService extends AgoraBaseService {
  @override
  Future<void> init() async {
    await super.init();
  }

  AgoraHostService._() : super();
  static AgoraHostService? _instance;
  static Future<AgoraHostService> instance() async {
    _instance ??= AgoraHostService._();
    return _instance!;
  }

  @override
  Future<void> ready() async {
    super.ready();

    ///
    await engine.startPreview(
        sourceType: VideoSourceType.videoSourceCameraSecondary);

    // // TODO: implement ready
    // throw UnimplementedError();
  }

  @override
  // TODO: implement controller
  VideoViewController get videoViewcontroller => VideoViewController(
      rtcEngine: engine,
      canvas: const VideoCanvas(
          //local userid -0
          uid: 0));

  @override
  // TODO: implement clientRole
  ClientRoleType get clientRole => ClientRoleType.clientRoleBroadcaster;

  @override
  Future<void> dispose() {
    // TODO: implement dispose
    throw UnimplementedError();
  }
}
