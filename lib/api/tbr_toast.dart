
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../util/toast.dart';

///统一吐司信息样式

class TBRToast {
  ///统一样式管理
  static double fontSize = 42.sp;
  static Color backgroundColor = const Color.fromRGBO(233, 233, 233, 0.8);
  static Color textColor = Colors.black;

  ///顶部信息
  static top(String msg) {
    ToastUtils.toast(msg);
    // Fluttertoast.cancel();
    // Fluttertoast.showToast(
    //   msg: msg,
    //   fontSize: fontSize,
    //   gravity: ToastGravity.TOP,
    //   backgroundColor: backgroundColor,
    //   textColor: textColor
    // );
  }

  ///居中信息
  static center(String msg) {
    ToastUtils.toast(msg);
    // Fluttertoast.cancel();
    // Fluttertoast.showToast(
    //     msg: msg,
    //     fontSize: fontSize,
    //     gravity: ToastGravity.CENTER,
    //     backgroundColor: backgroundColor,
    //     textColor: textColor
    // );
  }

  ///底部信息
  static bottom(String msg) {
    ToastUtils.toast(msg);
    // Fluttertoast.cancel();
    // Fluttertoast.showToast(
    //     msg: msg,
    //     fontSize: fontSize,
    //     gravity: ToastGravity.BOTTOM,
    //     backgroundColor: backgroundColor,
    //     textColor: textColor
    // );
  }

  /// 调试信息
  ///
  /// 只有在非生产环境下打印
  static d(String msg) {
    center(msg);
  }

  ///加载框
  static loading([String? status]){
    EasyLoading.show(
      status: status,
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false
    );
  }

  ///成功
  static success({required String status}){
    EasyLoading.showSuccess(status);
  }

  ///失败
  static error({required String status}){
    EasyLoading.showError(status);
  }


  ///取消加载框
  static cancel(){
    EasyLoading.dismiss();
  }



}

