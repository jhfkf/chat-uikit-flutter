import 'package:tencent_cloud_chat_uikit/data_services/message/aes.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'custom_message_ext_entity.dart';

extension CustomMessageExtEntityExtension on CustomMessageExtEntity {

  // 是不是名片消息
  bool get isUserCard => '16' == type;

  // 是不红包消息
  bool get isRedPacket => '17' == type;

  String get showName => AESUtil.decryptAESECB(name ?? "", "666888");

  String customLastMsgShow() {
    String msgShow = "";
    if (isUserCard) {
      msgShow = TIM_t("[名片消息]");
    }
    if (isRedPacket) {
      msgShow = TIM_t("[红包消息]");
    }
    return msgShow;
  }

  String get replyHintMsg  {
    String msgShow = "";
    if (isUserCard) {
      msgShow = "[名片消息] $showName的名片";
    }
    if (isRedPacket) {
      msgShow = "[红包消息]";
    }
    return msgShow;
  }
}
