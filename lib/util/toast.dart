import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';

// import 'commonUtils.dart';

class ToastUtils {
  static FToast? fToast;

  static void init(BuildContext context) {
    if (fToast == null) {
      fToast = FToast();
      fToast!.init(context);
    }
  }

  static double calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }

  static double calculateTextHeight(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '...',
    )..layout(maxWidth: maxWidth);
    return textPainter.height;
  }

  static Size calculateTextSize(String text, TextStyle style) {
    double width = 414;
    double height = 40;
    double textWidth = calculateTextWidth(text, style) + 60;
    width = min(width, textWidth);
    double textHeight = calculateTextHeight(text, style, width) + 30;
    height = min(height, textHeight);
    return Size(width, height);
  }

  static void toast(String msg) {
    if (PlatformUtils().isWindows) {
      EasyLoading.showToast(
          msg, toastPosition: EasyLoadingToastPosition.center);
      return;
    }
    TextStyle textStyle = const TextStyle(color: Colors.white);
    Size size = calculateTextSize(msg, textStyle);
    Widget toastItem = Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.black45,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              msg,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
          )
        ],
      ),
    );

    fToast?.showToast(
      gravity: ToastGravity.CENTER,
      child: toastItem,
    );
  }

  static void toastError(int code, String desc) {
    Fluttertoast.showToast(
      msg: "code:$code,desc:$desc",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 20,
      backgroundColor: Colors.black,
    );
  }

  static void log(Object? data) {
    bool prod =
        const bool.fromEnvironment('ISPRODUCT_ENV', defaultValue: false);
    if (!prod) {
      // ignore: avoid_print
      print("===================================");
      // ignore: avoid_print
      print("IM_DEMO_PRINT:$data");
      // ignore: avoid_print
      print("===================================");
    } else {}
  }
}
