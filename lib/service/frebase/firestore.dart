import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_streaming/core/error/error.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/service/auth_service.dart/auth_sevice.dart';

const avaiable_settingKey = ["theme", "isSound"];

class AppSetting {
  final String theme;
  final bool isSound;

  AppSetting({required this.theme, required this.isSound});
  factory AppSetting.fromJson(dynamic data) {
    final isMute = data["isSound"];
    return AppSetting(
        theme: data["theme"] ?? "light",
        isSound: isMute == null ? true : isMute == true);
  }
}

abstract class SettingBaseService {
  final FirebaseFirestore database;
  final AuthService service;
  SettingBaseService()
      : database = Locator<FirebaseFirestore>(),
        service = Locator<AuthService>();
  Future<Result<bool>> Write(String name, value);
  Stream setting();
  Future<AppSetting> Read();
}

class SettingService extends SettingBaseService {
  final user = AuthService().currentuser;
  @override
  Future<Result<bool>> Write(String key, value) async {
    if (!avaiable_settingKey.contains(key)) {
      return Result(error: GeneralError("InvalidKey"));
    }
    if (user == null) {
      return Result(error: GeneralError("Unauthorized"));
    }
    try {
      await database
          .collection("settings")
          .doc(user!.uid)
          .set({key: value}, SetOptions(merge: true));
      return Result(data: true);
    } on SocketException catch (e) {
      return Result(error: GeneralError(e.message));
    } on FirebaseException catch (e) {
      return Result(error: GeneralError(e.message ?? e.toString()));
    } catch (e) {
      return Result(error: GeneralError(e.toString()));
    }
  }

  @override
  Stream<AppSetting> setting() {
    if (user == null) {
      return const Stream.empty();
    }
    // TODO: implement setting
    return database
        .collection("settings")
        .doc(user!.uid)
        .snapshots()
        .map((event) {
      final data = event.data();

      if (data != null) {
        return AppSetting.fromJson(event.data());
      }
      return AppSetting(theme: "light", isSound: false);
    });
  }

  @override
  Future<AppSetting> Read() async {
    if (user == null) {
      return AppSetting(theme: "light", isSound: true);
    }
    final result = await database.collection("settings").doc(user?.uid).get();
    return AppSetting.fromJson(result.data());
  }
}
