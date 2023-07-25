import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/toast.dart';
import 'http.dart';
import 'tbr_toast.dart';

///接口返回数据模型
class DataResult {
  //服务器返回的json数据模型
  dynamic data;

  //此次接口返回的code
  int? code;

  //此次接口操作是否成功
  bool result;


  String? msg;

  //紧接着需要调用的方法-一般不需要用到
  Function? next;

  DataResult(this.data, this.result, {this.code, this.next, this.msg});
}

///Api方法封装
class UtilsApi {
  ///方法名 Unite_Post
  ///
  ///方法介绍 基本请求-通用
  ///
  ///@url - 请求url链接
  ///
  ///@requestData - 请求参数包
  ///
  ///@requestSuccessEvent - 请求成功回调事件
  ///
  ///@requestErrorEvent - 请求失败回调事件
  ///
  ///@timeoutEvent - 请求超时回调事件
  ///
  ///@timeoutTime - 超时时间-默认使用全局
  ///
  ///@isShowLoading - 是否需要显示加载动画
  ///
  ///@isPost - 是否是post请求
  ///
  ///@dismissToast - 是否去掉全局弹窗
  ///
  ///@loadingText - loading文本
  ///
  ///@isLongAwaitShow - 长时间等待是否出现加载弹窗
  ///
  ///@isPrintErrorLog - 是否打印报错msg
  ///
  ///@cancelToken - 请求取消用的token
  ///
  ///@isUnpack - 是否解包，默认只返回data里面的数据
  static Future<DataResult> baseUniversalPost({
    required String url,
    Map<String, dynamic>? params,
    Function? requestSuccessEvent,
    Function? requestErrorEvent,
    Function? timeoutEvent,
    Duration? timeoutTime,
    bool isShowLoading = false,
    bool isPost = true,
    bool isLongAwaitShow = true,
    bool isPrintErrorLog = true,
    bool dismissToast = true,
    bool isUnpack = true,
    String? loadingText,
    CancelToken? cancelToken,
  }) async {
    //此Api请求是否需要等待弹窗
    if (isShowLoading) {
      TBRToast.loading(loadingText);
    } else {
      //如果接口不需要加载动画 接口超过1000ms没有返回将会出现加载等待动画
      isShowLoading = true;
      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        if (isShowLoading && isLongAwaitShow) {
          TBRToast.loading(loadingText);
        }
      });
    }
    //拼接最终请求参数
    Map<String, dynamic> resParams = {
      "isUnpack": isUnpack,
    };
    resParams.addAll(params ?? {});
    //声明请求对象
    Future<Response> response;
    if (isPost) {
      response =
          httpManager.dio.post(url, data: resParams, cancelToken: cancelToken);
    } else {
      response = httpManager.dio
          .get(url, queryParameters: resParams, cancelToken: cancelToken);
    }
    // print(response);
    //链式结果回调
    return response.then((value) {
      if (requestSuccessEvent != null) requestSuccessEvent(value.data);
      return DataResult(value.data, true, code: value.statusCode);
    }).timeout(
      timeoutTime ??
          Duration(milliseconds: httpManager.dio.options.receiveTimeout),

      /// 超时时间
      onTimeout: () async {
        if (timeoutEvent != null) timeoutEvent();
        // TbrLog.d('请求超时=>$url');
        return DataResult({}, false);
      },
    ).onError((e, stackTrace) {
      /// 请求出错
      String? log;
      if (e is DioError) {
        log = e.response?.data;
      } else if (e is String) {
        log = e;
      }
      // TbrLog.e('请求错误=>$url=>$log');
      if (requestErrorEvent != null) requestErrorEvent(log);
      if (isPrintErrorLog &&
          (e is DioError) &&
          e.response != null &&
          (e.response!).data != null) {
        DioError error = e;
        ToastUtils.toast((error.response!).data.toString());
      }
      return DataResult(e, false);
    }).catchError((e) {
      /// 异常
      String? log;
      if (e is DioError) {
        log = e.response?.data;
      } else if (e is String) {
        log = e;
      }
      // TbrLog.e('请求异常=>$url=>$log');
      if (requestErrorEvent != null) requestErrorEvent(log);
      if (isPrintErrorLog &&
          (e is DioError) &&
          e.response != null &&
          (e.response!).data != null) {
        DioError error = e;
        ToastUtils.toast((error.response!).data.toString());
      }
      return DataResult(e, false);
    }).whenComplete(() {
      if (dismissToast) {
        TBRToast.cancel();
        isShowLoading = false;
      }
    });
  }

  ///方法名 Unite_Post
  ///
  ///方法介绍 基本请求-通用
  ///
  ///@url - 请求url链接
  ///
  ///@requestData - 请求参数包
  ///
  ///@requestSuccessEvent - 请求成功回调事件
  ///
  ///@requestErrorEvent - 请求失败回调事件
  ///
  ///@timeoutEvent - 请求超时回调事件
  ///
  ///@timeoutTime - 超时时间-默认使用全局
  ///
  ///@isShowLoading - 是否需要显示加载动画
  ///
  ///@isPost - 是否是post请求
  ///
  ///@dismissToast - 是否去掉全局弹窗
  ///
  ///@loadingText - loading文本
  ///
  ///@isLongAwaitShow - 长时间等待是否出现加载弹窗
  ///
  ///@isPrintErrorLog - 是否打印报错msg
  ///
  ///@cancelToken - 请求取消用的token
  ///
  ///@isUnpack - 是否解包，默认只返回data里面的数据
  static Future<DataResult> baseQueryPost({
    required String url,
    Map<String, dynamic>? params,
    Function? requestSuccessEvent,
    Function? requestErrorEvent,
    Function? timeoutEvent,
    Duration? timeoutTime,
    bool isShowLoading = false,
    bool isPost = true,
    bool isLongAwaitShow = true,
    bool isPrintErrorLog = true,
    bool dismissToast = true,
    bool isUnpack = true,
    String? loadingText,
    CancelToken? cancelToken,
  }) async {
    //此Api请求是否需要等待弹窗
    if (isShowLoading) {
      TBRToast.loading(loadingText);
    } else {
      //如果接口不需要加载动画 接口超过1000ms没有返回将会出现加载等待动画
      isShowLoading = true;
      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        if (isShowLoading && isLongAwaitShow) {
          TBRToast.loading(loadingText);
        }
      });
    }
    //拼接最终请求参数
    Map<String, dynamic> resParams = {
      "isUnpack": isUnpack,
    };
    resParams.addAll(params ?? {});
    //声明请求对象
    Future<Response> response;
    if (isPost) {
      response = httpManager.dio
          .post(url, queryParameters: resParams, cancelToken: cancelToken);
    } else {
      response = httpManager.dio
          .get(url, queryParameters: resParams, cancelToken: cancelToken);
    }
    // print(response);
    //链式结果回调
    return response.then((value) {
      if (requestSuccessEvent != null) requestSuccessEvent(value.data);
      return DataResult(value.data, true, code: value.statusCode);
    }).timeout(
      timeoutTime ??
          Duration(milliseconds: httpManager.dio.options.receiveTimeout),

      /// 超时时间
      onTimeout: () async {
        if (timeoutEvent != null) timeoutEvent();
        // TbrLog.d('请求超时=>$url');
        return DataResult({}, false);
      },
    ).onError((e, stackTrace) {
      /// 请求出错
      String? log;
      if (e is DioError) {
        log = e.response?.data;
      } else if (e is String) {
        log = e;
      }
      // TbrLog.e('请求错误=>$url=>$log');
      // if (requestErrorEvent != null) requestErrorEvent(log);
      if (isPrintErrorLog &&
          (e is DioError) &&
          e.response != null &&
          (e.response!).data != null) {
        DioError error = e;
        ToastUtils.toast((error.response!).data.toString());
      }
      return DataResult(e, false, msg: log);
    }).catchError((e) {
      /// 异常
      String? log;
      if (e is DioError) {
        log = e.response?.data;
      } else if (e is String) {
        log = e;
      }
      // TbrLog.e('请求异常=>$url=>$log');
      if (requestErrorEvent != null) requestErrorEvent(log);
      if (isPrintErrorLog &&
          (e is DioError) &&
          e.response != null &&
          (e.response!).data != null) {
        DioError error = e;
        ToastUtils.toast((error.response!).data.toString());
      }
      return DataResult(e, false, msg: log);
    }).whenComplete(() {
      if (dismissToast) {
        TBRToast.cancel();
        isShowLoading = false;
      }
    });
  }

  ///方法名 Unite_Post
  ///
  ///方法介绍 基本请求-通用
  ///
  ///@url - 请求url链接
  ///
  ///@requestData - 请求参数包
  ///
  ///@requestSuccessEvent - 请求成功回调事件
  ///
  ///@requestErrorEvent - 请求失败回调事件
  ///
  ///@timeoutEvent - 请求超时回调事件
  ///
  ///@timeoutTime - 超时时间-默认使用全局
  ///
  ///@isShowLoading - 是否需要显示加载动画
  ///
  ///@isPost - 是否是post请求
  ///
  ///@dismissToast - 是否去掉全局弹窗
  ///
  ///@loadingText - loading文本
  ///
  ///@isLongAwaitShow - 长时间等待是否出现加载弹窗
  ///
  ///@isPrintErrorLog - 是否打印报错msg
  ///
  ///@cancelToken - 请求取消用的token
  ///
  ///@isUnpack - 是否解包，默认只返回data里面的数据
  static Future<DataResult> baseUpload({
    required String url,
    Map<String, dynamic>? params,
    Function? requestSuccessEvent,
    Function? requestErrorEvent,
    Function? timeoutEvent,
    Duration? timeoutTime,
    bool isShowLoading = false,
    bool isPrintErrorLog = true,
    bool dismissToast = true,
    bool isUnpack = false,
    String? loadingText,
    CancelToken? cancelToken,
  }) async {
    //此Api请求是否需要等待弹窗
    if (isShowLoading) {
      TBRToast.loading(loadingText);
    } else {
      //如果接口不需要加载动画 接口超过1000ms没有返回将会出现加载等待动画
      isShowLoading = true;
      if (isShowLoading) {
        TBRToast.loading(loadingText);
      }
    }
    //拼接最终请求参数
    Map<String, dynamic> resParams = {
      "isUnpack": isUnpack,
    };
    resParams.addAll(params ?? {});

    ///通过FormData
    FormData formData = FormData.fromMap(resParams);
    //声明请求对象
    Future<Response> response = httpManager.dio.post(
      url,
      data: formData,
      cancelToken: cancelToken,
      onReceiveProgress: (int progress, int total) {
        print("当前进度是 $progress 总进度是 $total");
      },
    );
    // print(response);
    //链式结果回调
    return response.then((value) {
      if (requestSuccessEvent != null) requestSuccessEvent(value.data);
      return DataResult(value.data, true, code: value.statusCode);
    }).timeout(
      timeoutTime ??
          Duration(milliseconds: httpManager.dio.options.receiveTimeout),

      /// 超时时间
      onTimeout: () async {
        if (timeoutEvent != null) timeoutEvent();
        // TbrLog.d('请求超时=>$url');
        return DataResult({}, false);
      },
    ).onError((e, stackTrace) {
      /// 请求出错
      String? log;
      if (e is DioError) {
        log = e.response?.data;
      } else if (e is String) {
        log = e;
      }
      // TbrLog.e('请求错误=>$url=>$log');
      if (requestErrorEvent != null) requestErrorEvent(log);
      if (isPrintErrorLog &&
          (e is DioError) &&
          e.response != null &&
          (e.response!).data != null) {
        DioError error = e;
        ToastUtils.toast((error.response!).data.toString());
      }
      return DataResult(e, false);
    }).catchError((e) {
      /// 异常
      String? log;
      if (e is DioError) {
        log = e.response?.data;
      } else if (e is String) {
        log = e;
      }
      // TbrLog.e('请求异常=>$url=>$log');
      if (requestErrorEvent != null) requestErrorEvent(log);
      if (isPrintErrorLog &&
          (e is DioError) &&
          e.response != null &&
          (e.response!).data != null) {
        DioError error = e;
        ToastUtils.toast((error.response!).data.toString());
      }
      return DataResult(e, false);
    }).whenComplete(() {
      if (dismissToast) {
        TBRToast.cancel();
        isShowLoading = false;
      }
    });
  }

  /// 通过隔离线程请求
  Future<DataResult> requestCompute(
      Future<DataResult> Function(String) event) async {
    return await compute(event, '');
  }

  imgUpToTX(String imagePath) {
    httpManager.dio.put(imagePath);
  }
}
