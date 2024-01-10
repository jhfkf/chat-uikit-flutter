import 'package:collection/collection.dart';

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

    // String conversationID = "";
    // if (isUser) {
    //   conversationID = "c2c_$key";
    // } else {
    //   conversationID = "group_$key";
    // }
    // var res = await DisturbCheckHelper()
    //     .sdkInstance
    //     .getConversationManager()
    //     .getConversation(conversationID: conversationID);

    if (isUser) {
      V2TimValueCallback<List<V2TimReceiveMessageOptInfo>> messageOpt =
          await DisturbCheckHelper()
              .sdkInstance
              .getMessageManager()
              .getC2CReceiveMessageOpt(userIDList: [key]);
      V2TimReceiveMessageOptInfo? info = messageOpt.data?.firstOrNull;
      if (info != null) {
        bool disturb = info.c2CReceiveMessageOpt != 0;
        disturbMap[key] = disturb;
        return disturb;
      }
    } else {
      // V2TimValueCallback<List<V2TimGroupInfoResult>> groups =
      //     await TencentImSDKPlugin.v2TIMManager
      //         .getGroupManager()
      //         .getGroupsInfo(groupIDList: [key]);
      // groups.data?.forEach((element) {
      //   // 获取群组的接收消息选项
      //   print(element.groupInfo?.recvOpt ?? "");
      // });
      V2TimValueCallback<List<V2TimGroupInfoResult>> groups =
          await DisturbCheckHelper()
              .sdkInstance
              .getGroupManager()
              .getGroupsInfo(groupIDList: [key]);
      V2TimGroupInfo? info = groups.data?.firstOrNull?.groupInfo;
      if (info != null) {
        bool disturb = info.recvOpt != 0;
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
