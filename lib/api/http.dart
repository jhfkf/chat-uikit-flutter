import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'interceptors.dart';

class HttpManager {
  /// 基础请求头-不变的放这里-动态改变的调用方法修改
  // PackageInfo packageInfo = await PackageInfo.fromPlatform();
  // String version = packageInfo.version;
  final Map<String, dynamic> _requestHeaders = {
    // 'loginRole': "3",
  };

  /// dio对象
  final Dio _tbrDio = Dio();

  Dio get dio => _tbrDio;

  HttpManager() {
    //cookie管理
    setDioBaseOptions(baseUrl: 'https://q.sqapi.com/user/', headers: {});
    // 添加请求拦截器
    dio.interceptors.add(TBRInterceptors());
    SharedPreferences.getInstance().then((prefs) {
      String? baseUrl = prefs.getString('TUIBaseUrl');
      if (baseUrl != null) {
        setDioBaseOptions(baseUrl: baseUrl, headers: {});
      }
    });
  }

  /// 设置请求头
  ///
  /// @headers - 请求头字典
  ///
  /// @baseUrl - 接口根域名
  ///
  /// @contentType - 请求类型
  ///
  /// @responseType - 返回类型
  ///
  /// @connectTimeout - 链接超时时间 ms
  ///
  /// @receiveTimeout - 响应超时时间 ms
  void setDioBaseOptions({
    Map<String, dynamic>? headers,
    String? baseUrl,
    String? contentType,
    ResponseType? responseType,
    int? connectTimeout,
    int? receiveTimeout,
  }) {
    // 拼接基础请求头
    if (headers == null) {
      headers = _requestHeaders;
    } else {
      headers.addAll(_requestHeaders);
    }

    dio.options = BaseOptions(
      baseUrl: baseUrl ?? 'https://q.sqapi.com/user/',
      contentType: contentType ?? "application/json",
      responseType: responseType ?? ResponseType.plain,
      headers: headers,

      /// 链接超时
      connectTimeout: Duration(milliseconds: connectTimeout ?? 60 * 1000),

      /// 响应超时
      receiveTimeout: Duration(milliseconds: receiveTimeout ?? 60 * 1000),
    );
  }
}

class AESUtil {
  //加密方法，先进行加密后再使用base64对加密字符串进行编码
  static String generateAES(String data, String keyStr, String ivStr) {
    final plainText = data;
    final key = encrypt.Key.fromUtf8(keyStr);
    final iv = encrypt.IV.fromUtf8(ivStr);
    final encrypter = encrypt.Encrypter(encrypt.AES(key,
        mode: encrypt.AESMode.cbc /*指定使用CBC模式(AES/CBC/PKCS5PADDING)*/));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    //将已经加密的字符串进行base64编码后再传递给服务器
    return encrypted.base64;
  }

  //解密方法，服务器返回已经编码的base64字符串，要先对其进行解码后再执行解密操作
  static String decryptAES(String data, String keyStr, String ivStr) {
    final plainText = data;
    //先将服务器返回base64类型字符串解码
    List<int> bytes2 = base64Decode(data);
    String decode64Str = String.fromCharCodes(bytes2);

    //构建为三方库需要的数据类型
    List<int> list = decode64Str.codeUnits;
    Uint8List dataBytes = Uint8List.fromList(list);
    final encrypted = encrypt.Encrypted(dataBytes);

    //使用密钥进行解密
    final key = encrypt.Key.fromUtf8(keyStr);
    final iv = encrypt.IV.fromUtf8(ivStr);
    final encrypter = encrypt.Encrypter(encrypt.AES(key,
        mode: encrypt.AESMode.cbc /*指定使用CBC模式(AES/CBC/PKCS5PADDING)*/));

    final str = encrypter.decrypt(encrypted, iv: iv);
    return str;
  }

  //拼接规则-传入需要加密的字符串返回加密字符串
  static String encryptedStr({required String str}) {
    //随机数
    String random = '';
    for (int i = 0; i < 6; i++) {
      int nub = Random().nextInt(10);
      random = random + '$nub';
    }
    //拼接
    String all = '';
    all = str +
        '-' +
        DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10) +
        '|' +
        random;
    return all;
  }
}

final HttpManager httpManager = HttpManager();
