import '../tencent_cloud_chat_uikit.dart';

extension V2TimConversationExt on V2TimConversation {

  static int _higherStatus = 0;

  static int _goodStatus = 0;

  static Map conversationVipMap = {};

  static Map conversationGoodMap = {};

  int get goodStatus {
    if (conversationGoodMap.keys.contains(groupID)) {
      return conversationGoodMap[groupID];
    }
    return _goodStatus;
  }

  set goodStatus(int value) {
    _goodStatus = value;
    if (groupID != null) {
      conversationGoodMap[groupID] = value;
    }
  }

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

  String? get showGoodImageStr {
    if (groupID == null || userID != null) {
      return null;
    }
    if (goodStatus == 1) {
      return "assets/liang_fang.png";
    }
    if (goodStatus == 2) {
      return "assets/liang_quan.png";
    }
    return null;
  }

  String? showGoodImageStrByMap(Map? info) {
    if (info == null) return null;
    if (groupID == null && userID == null) {
      return null;
    }
    int goodStatus = 0;
    if (groupID != null) {
      if (info.keys.contains("group_goodStatus_$groupID")) {
        goodStatus = info["group_goodStatus_$groupID"];
      }
    }
    if (userID != null) {
      if (info.keys.contains("user_goodStatus_$userID")) {
        goodStatus = info["user_goodStatus_$userID"];
      }
    }
    if (goodStatus == 1) {
      return "assets/liang_fang.png";
    }
    if (goodStatus == 2) {
      return "assets/liang_quan.png";
    }
    return null;
  }

  String? showIconImageStrByMap(Map? info) {
    if (info == null) return null;
    if (groupID == null || userID != null) {
      return null;
    }
    int higherStatus = 0;
    if (info.keys.contains("group_higherStatus_$groupID")) {
      higherStatus = info["group_higherStatus_$groupID"];
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
