import '../tencent_cloud_chat_uikit.dart';

extension V2TimConversationExt on V2TimConversation {
  static int _higherStatus = 0;

  int get higherStatus => _higherStatus;

  set higherStatus(int value) => _higherStatus = value;


  String? get showIconImageStr {
    if (groupID == null || userID != null) {
      return null;
    }
    if (_higherStatus == 1 ||  _higherStatus == 2) {
      if (_higherStatus == 1) {
        return "assets/group_icon_vip.png";
      }
      return "assets/group_icon_svip.png";
    }
    return null;
  }

}
