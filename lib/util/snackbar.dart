import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/util/toast.dart';

class SnackBarUtils {

  static showMsg(String msg) {
    ToastUtils.toast(msg);
    // Get.snackbar(
    //   "",
    //   "",
    //   titleText: const Text(
    //     "温馨提示",
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //       fontWeight: FontWeight.w800,
    //       fontSize: 16,
    //     ),
    //   ),
    //   messageText: Text(
    //     msg,
    //     textAlign: TextAlign.center,
    //     style: const TextStyle(
    //       fontWeight: FontWeight.w300,
    //       fontSize: 14,
    //     ),
    //   ),
    // );
  }

  static showNoPrivateChat() {
    ToastUtils.toast("该群禁止私聊");
    // Get.snackbar(
    //   "",
    //   "",
    //   titleText: const Text(
    //     "温馨提示",
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //       fontWeight: FontWeight.w800,
    //       fontSize: 16,
    //     ),
    //   ),
    //   messageText: const Text(
    //     "该群禁止私聊",
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //       fontWeight: FontWeight.w300,
    //       fontSize: 14,
    //     ),
    //   ),
    // );
  }
}
