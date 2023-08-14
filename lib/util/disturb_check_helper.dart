import '../data_services/conversation/conversation_services.dart';
import '../data_services/friendShip/friendship_services.dart';
import '../data_services/group/group_services.dart';
import '../data_services/services_locatar.dart';
import '../tencent_cloud_chat_uikit.dart';

class DisturbCheckHelper {

  final sdkInstance = TIMUIKitCore.getSDKInstance();

  static Map<String, bool> disturbMap = {};

  //私有构造函数
  DisturbCheckHelper._internal();

  //保存单例
  static final DisturbCheckHelper _singleton = DisturbCheckHelper._internal();

  //工厂构造函数
  factory DisturbCheckHelper() => _singleton;

  static Future<bool> check(String key, bool isUser) async {
    if (disturbMap.containsKey(key)) {
      if (disturbMap.containsKey(key)) {
        return disturbMap[key] ?? false;
      }
    }
    String conversationID = "";
    if (isUser) {
      conversationID = "c2c_$key";
    }else {
      conversationID = "group_$key";
    }
    var res = await DisturbCheckHelper().sdkInstance
        .getConversationManager().getConversation(
        conversationID: conversationID);
    if (res.code == 0) {
      if (isUser) {
        final V2TimConversation conversation = res.data ??
            V2TimConversation(
                conversationID: conversationID, userID: key, type: 1);
        bool disturb = conversation.recvOpt == 2;
        disturbMap[key] = disturb;
        return disturb;
      }else {
        final V2TimConversation conversation = res.data ??
            V2TimConversation(
                conversationID: conversationID, groupID: key, type: 2);
        bool disturb = conversation.recvOpt == 2;
        disturbMap[key] = disturb;
        return disturb;
      }
    }
    return false;
  }

  static void update(String key, bool disturb) {
    disturbMap[key] = disturb;
  }

}
