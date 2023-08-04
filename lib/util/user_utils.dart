import '../tencent_cloud_chat_uikit.dart';

class UserUtils {
  static Future<String> loginUser() async {
    final res = await TIMUIKitCore.getSDKInstance().getLoginUser();
    if (res.code != 0) {
      return "";
    }
    return res.data!;
  }
}
