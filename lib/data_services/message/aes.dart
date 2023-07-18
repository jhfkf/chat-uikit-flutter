import 'dart:convert' as convert;
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

class AESUtil {
  //加密方法，先进行加密后再使用base64对加密字符串进行编码
  static String generateAES(String data, String keyStr, String ivStr) {
    final plainText = data;
    final key = Key.fromUtf8(keyStr);
    final iv = IV.fromUtf8(ivStr);
    final encrypt = Encrypter(
        AES(key, mode: AESMode.cbc /*指定使用CBC模式(AES/CBC/PKCS5PADDING)*/));
    final encrypted = encrypt.encrypt(plainText, iv: iv);

    //将已经加密的字符串进行base64编码后再传递给服务器
    return encrypted.base64;
  }

  //解密方法，服务器返回已经编码的base64字符串，要先对其进行解码后再执行解密操作
  static String decryptAES(String data, String keyStr, String ivStr) {
    // final plainText = data;
    //先将服务器返回base64类型字符串解码
    List<int> bytes2 = convert.base64Decode(data);
    String decode64Str = String.fromCharCodes(bytes2);

    //构建为三方库需要的数据类型
    List<int> list = decode64Str.codeUnits;
    Uint8List dataBytes = Uint8List.fromList(list);
    final encrypted = Encrypted(dataBytes);

    //使用密钥进行解密
    final key = Key.fromUtf8(keyStr);
    final iv = IV.fromUtf8(ivStr);
    final encrypter = Encrypter(
        AES(key, mode: AESMode.cbc /*指定使用CBC模式(AES/CBC/PKCS5PADDING)*/));

    final str = encrypter.decrypt(encrypted, iv: iv);
    return str;
  }

  //加密方法，先进行加密后再使用base64对加密字符串进行编码
  static String generateAESECB(String data, String keyStr) {
    final plainText = data;
    var keyList = Uint8List.fromList(convert.utf8.encode(keyStr));
    var key = Key(Uint8List.fromList(keyList));
    if (keyStr.length < 16) {
      var keyList = Uint8List.fromList(convert.utf8.encode(keyStr)) +
          Uint8List(16 - keyStr.length);
      key = Key(Uint8List.fromList(keyList));
    }
    final iv = IV.fromUtf8('');
    final encrypt = Encrypter(
      AES(key, mode: AESMode.ecb),
    );
    final encrypted = encrypt.encrypt(plainText, iv: iv);
    // 将已经加密的字符串进行base64编码后再传递给服务器
    return encrypted.base64;
  }

  //解密方法，服务器返回已经编码的base64字符串，要先对其进行解码后再执行解密操作
  static String decryptAESECB(String data, String keyStr) {
    // var result = runZonedGuarded(() {
    try {
      //先将服务器返回base64类型字符串解码
      List<int> bytes2 = convert.base64Decode(data);
      String decode64Str = String.fromCharCodes(bytes2);
      //构建为三方库需要的数据类型
      List<int> list = decode64Str.codeUnits;
      Uint8List dataBytes = Uint8List.fromList(list);

      var encrypted = Encrypted(dataBytes);
      //使用密钥进行解密
      var key = Key.fromUtf8(keyStr);
      final iv = IV.fromUtf8('');
      if (keyStr.length < 16) {
        var keyList = Uint8List.fromList(convert.utf8.encode(keyStr)) +
            Uint8List(16 - keyStr.length);
        key = Key(Uint8List.fromList(keyList));
      }
      final encrypt = Encrypter(
        AES(key, mode: AESMode.ecb),
      );
      final str = encrypt.decrypt(encrypted, iv: iv);
      return str;
    } catch (e) {
      print(e);
      return data;
    }
    // }, (error, stack) {
    //   print('zone捕获到了异步异常');
    // }) ?? data;
    // result = result ?? data;
    // return result;
  }

  //拼接规则-传入需要加密的字符串返回加密字符串
  static String encryptedStr({required String str}) {
    //随机数
    String random = '';
    for (int i = 0; i < 6; i++) {
      int nub = Random().nextInt(10);
      random = '$random$nub';
    }
    //拼接
    String all = '';
    all =
    '$str-${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10)}|$random';
    return all;
  }
}