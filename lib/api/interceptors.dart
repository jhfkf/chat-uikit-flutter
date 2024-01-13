import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/toast.dart';

/// 请求拦截器
class TBRInterceptors extends InterceptorsWrapper {
  bool needAuthorization(RequestOptions options) {
    bool result = true;
    if (options.path.endsWith("appLogin") ||
        options.path.endsWith("codeLogin")) {
      result = false;
    }
    return result;
  }

  bool isUpload(RequestOptions options) {
    bool result = false;
    if (options.path.endsWith("common/uploadAvatar")) {
      result = true;
    }
    return result;
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // TODO: implement onRequest
    //请求头添加token
    //请求头添加token
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    if (prefs.get('token') != null && needAuthorization(options)) {
      options.headers["Authorization"] = prefs.get('token');
    }
    if (options.path.endsWith("app/user/queryUserId")) {
      options.contentType = 'application/x-www-form-urlencoded';
    }else {
      options.contentType = "application/json";
    }
    //调式环境下打印请求信息
   debugPrint(
        '====================接口请求====================\n请求时间=>${DateTime.now()}\n请求token=>${prefs.get('token')}\n接口类型=>${options.method}\n接口路径=>${options.baseUrl}${options.path}\n接口参数=>${options.method == 'POST' ? options.data.toString() : options.queryParameters.toString()}');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // TODO: implement onResponse
    RequestOptions option = response.requestOptions;

    debugPrint(
        '====================接口响应====================\n响应时间=>${DateTime.now()}\n接口类型=>${option.method}\n接口路径=>${option.path}\n接口参数=>${option.method == 'POST' ? option.data.toString() : option.queryParameters.toString()}\n接口返回=>${response.data}');

    try {
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        if (option.data is! Map) {
        } else if ((option.data == null ? false : !(option.data['isUnpack'])) ||
            (option.queryParameters.isEmpty
                ? false
                : !(option.queryParameters['isUnpack']))) {
          ///不解包
          return handler.resolve(response);
        }

        ///将请求回来的数据转换为Map格式
        Map map = jsonDecode(response.data) ?? {};

        if (!map.containsKey('code') || map['code'] == null) {
          return handler.reject(DioError(
              requestOptions: option,
              response: Response(data: 'code为空', requestOptions: option)));
        } else if (map['code'] == 200) {
          /// 请求成功
          if (map.keys.contains('data')) {
            return handler
                .resolve(Response(data: map['data'], requestOptions: option));
          }
          if (isUpload(option)) {
            return handler.resolve(Response(data: map, requestOptions: option));
          }
          return handler.resolve(Response(data: null, requestOptions: option));
        } else if (map['code'] == 401 || map['code'] == 1401) {
          //token 无效
          // user.cleanData();
          // im.loginOut();
          ToastUtils.toast('登录状态失效!');
          // TbrJVerify.requestLoginAuth();
          return handler.reject(DioError(
            requestOptions: option,
            response: null,
          ));
        } else if (map['code'] == 500) {
          return handler.reject(DioError(
            requestOptions: option,
            response:
                Response(data: '${map['msg']}', requestOptions: option),
          ));
        } else if (map['code'] < 100000) {
          return handler.reject(DioError(
            requestOptions: option,
            response: Response(data: '${map['msg']}', requestOptions: option),
          ));
        } else {
          if (kDebugMode) {
            return handler.reject(DioError(
                requestOptions: option,
                response: Response(
                    data: '未定义的code码=>${map['code']}',
                    requestOptions: option)));
          }
          return handler.reject(DioError(
              requestOptions: option,
              response: Response(data: '系统出错，请稍后再试！', requestOptions: option)));
        }
      }
      // Code.errorHandleFunction(400, data.msg);
      // return _dio.reject(data.toJson());
      return handler.resolve(
          Response(data: jsonDecode(response.data), requestOptions: option));
    } catch (e) {
      // Code.errorHandleFunction(400, data.msg);
      // return _dio.reject(data.toJson());
      return handler.reject(DioError(
        requestOptions: option,
        response: Response(data: e.toString(), requestOptions: option),
      ));
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    String error =
        '====================接口异常====================\n请求时间=>${DateTime.now()}\n接口类型=>${err.requestOptions.method}\n接口路径=>${err.requestOptions.path}\n异常参数=>${err.requestOptions.method == 'POST' ? err.requestOptions.data.toString() : err.requestOptions.queryParameters.toString()}\n异常信息=>${err.message}';
    // TbrLog.d(error);
    return super.onError(err, handler);
  }
}
