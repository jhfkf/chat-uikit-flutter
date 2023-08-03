import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarUtils {
  static showNoPrivateChat() {
    Get.snackbar(
      "",
      "",
      titleText: const Text(
        "温馨提示",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
      messageText: const Text(
        "该群禁止私聊",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
      ),
    );
  }
}
