import 'package:flutter/material.dart';
import 'package:live_streaming/core/model/result.dart';
import 'package:starlight_utils/starlight_utils.dart';

class Quit {
  const Quit();
}

class SoftQuit extends Quit {
  const SoftQuit();
}

class ForceQuit extends Quit {
  const ForceQuit();
}

Future<Result> showErrorDialog<T extends Object>(
  String title,
  String content, {
  String defaultActionButtonLabel = "OK",
  bool usedefaultaction = true,
  List<Widget> action = const [],
  bool showdefaultActionOnRight = true,
}) async {
  final result = await StarlightUtils.dialog(
    AlertDialog(
        shape: const RoundedRectangleBorder(),
        title: Text(title),
        content: Text(content),
        actions: [
          if (usedefaultaction && !showdefaultActionOnRight)
            TextButton(
                onPressed: () {
                  StarlightUtils.pop(result: const SoftQuit());
                },
                child: Text(defaultActionButtonLabel)),
          ...action,
          if (usedefaultaction && showdefaultActionOnRight)
            TextButton(
                onPressed: () {
                  StarlightUtils.pop(result: const SoftQuit());
                },
                child: Text(defaultActionButtonLabel))
        ],
        actionsPadding: const EdgeInsets.only(
          bottom: 10,
          right: 10,
        )),
    barrierDismissible: false,
  );
  print("quick1 is $result");
  if (result != null) {
    if (result is T) return Result(data: result);
  } else if (result == null) {
    return Result(data: const ForceQuit());
  }
  return Result(data: const SoftQuit());
}
