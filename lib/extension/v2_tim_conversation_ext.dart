import '../tencent_cloud_chat_uikit.dart';

extension V2TimConversationExt on V2TimConversation {

  static int _higherStatus = 0;

  static Map conversationVipMap = {};

  int get higherStatus {
    if (conversationVipMap.keys.contains(groupID)) {
      return conversationVipMap[groupID];
    }
    return _higherStatus;
  }

  set higherStatus(int value) {
    _higherStatus = value;
    if (groupID != null) {
      conversationVipMap[groupID] = value;
    }
  }

  String? get showIconImageStr {
    if (groupID == null || userID != null) {
      return null;
    }
    if (higherStatus == 1 ||  higherStatus == 2) {
      if (higherStatus == 1) {
        return "assets/group_icon_vip.png";
      }
      return "assets/group_icon_svip.png";
    }
    return null;
  }

}
