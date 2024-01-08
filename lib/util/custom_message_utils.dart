import 'dart:convert';

import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../extension/custom_message_ext_entity.dart';

class CustomMessageUtils {
  // 是否是是自定义的扩展消息
  static CustomMessageExtEntity? messageCustomExt(V2TimMessage message) {
    final isCustomMessage =
        message.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM;
    if (isCustomMessage) {
      final customElemData = message.customElem?.data ?? "";
      var dic = jsonDecode(customElemData);
      CustomMessageExtEntity extEntity = CustomMessageExtEntity.fromJson(dic);
      if (extEntity.type != null) {
        return extEntity;
      }
    }
    return null;
  }
}
