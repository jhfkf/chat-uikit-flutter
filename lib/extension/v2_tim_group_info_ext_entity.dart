import 'dart:convert';

import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../generated/json/base/json_field.dart';
import '../generated/json/v2_tim_group_info_ext_entity.g.dart';
import '../util/time_utils.dart';

@JsonSerializable()
class V2TimGroupInfoExtEntity {
  @JSONField(name: "expire_date")
  String? expireDate;
  @JSONField(name: "forbid_back")
  int? forbidBack;
  @JSONField(name: "higher_status")
  int? higherStatus;
  @JSONField(name: "notice_mode")
  int? noticeMode;
  @JSONField(name: "private_mode")
  int? privateMode;
  @JSONField(name: "good_number")
  int? goodNumber;
  @JSONField(name: "name_colour")
  String? nameColour;
  @JSONField(name: "icon_url")
  String? iconUrl;

  V2TimGroupInfoExtEntity();

  factory V2TimGroupInfoExtEntity.fromJson(Map<String, dynamic> json) =>
      $V2TimGroupInfoExtEntityFromJson(json);

  Map<String, dynamic> toJson() => $V2TimGroupInfoExtEntityToJson(this);

  V2TimGroupInfoExtEntity copyWith(
      {String? expireDate,
      String? nameColour,
      String? iconUrl,
      int? forbidBack,
      int? higherStatus,
      int? noticeMode,
      int? privateMode,
      int? goodNumber}) {
    return V2TimGroupInfoExtEntity()
      ..expireDate = expireDate ?? this.expireDate
      ..nameColour = nameColour ?? this.nameColour
      ..iconUrl = iconUrl ?? this.iconUrl
      ..forbidBack = forbidBack ?? this.forbidBack
      ..higherStatus = higherStatus ?? this.higherStatus
      ..noticeMode = noticeMode ?? this.noticeMode
      ..privateMode = privateMode ?? this.privateMode
      ..goodNumber = goodNumber ?? this.goodNumber;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}

// {expire_date: 2024-06-21 00:00:00, forbid_back: 1, good_number: 1, higher_status: 3, icon_url: http://appapi.sxpan.com/a/01.png, name_colour: 9b59b6, notice_mode: 0, private_mode: 1}
// {"expire_date":"2024-07-20 00:00:01","forbid_back":0,"higher_status":2,"notice_mode":0,"private_mode":1}
//// 公告提示（参数：0或1）（权限：可读/可写）
//@property (nonatomic, copy) NSString *notice_mode;
//
//// 到期时间（显示到期时间）（权限：可读）
//@property (nonatomic, copy) NSString *expire_date;
//
//// 禁止撤回（参数：0或1）（权限：可读/可写）
//@property (nonatomic, copy) NSString *forbid_back;
//
//// 群组等级（参数：0,1,2,3 [0=200人普通群.1=500人高级群.2=1000人千人群.3=2000人SVIP群]）（权限：可读）
//@property (nonatomic, copy) NSString *higher_status;
//
//// 禁止私聊（参数：0或1）（权限：可读/可写）
//@property (nonatomic, copy) NSString *private_mode;
extension V2TimUserFullInfoExt on V2TimGroupInfo {
  V2TimGroupInfoExtEntity get extInfo {
    return V2TimGroupInfoExtEntity.fromJson(customInfo ?? {});
  }

  // 是否开启通知
  bool get isEnabledNoticeMode => extInfo.noticeMode == 1;

  // 是否禁止撤回
  bool get isEnabledForbidBack => extInfo.forbidBack == 1;

  // 是否 vip
  bool get isNormalVip =>
      extInfo.higherStatus == 1 || extInfo.higherStatus == 2;

  // 是否 svip
  bool get isSuperVip => extInfo.higherStatus == 3;

  // 是否 是靓号
  int get isGoodNum => extInfo.goodNumber == 1 ? 1 : 0;

  // 是否禁止私聊
  bool get isPrivate => extInfo.privateMode == 1;

  String? get showIconImageStr {
    if (isNormalVip || isSuperVip) {
      if (isNormalVip) {
        return "assets/group_icon_vip.png";
      }
      return "assets/group_icon_svip.png";
    }
    return null;
  }

  String get nameColorHex {
    if (isGoodNum == 1) {
      String nameColour = extInfo.nameColour ?? "";
      if (nameColour.isNotEmpty) {
        return nameColour;
      }
      return "ff0000";
    }
    return "";
  }

  String get showGoodNumImageStr {
    if (isGoodNum == 1) {
      String iconUrl = extInfo.iconUrl ?? "";
      if (iconUrl.isNotEmpty) {
        return iconUrl;
      }
      return "assets/liang_quan.png";
    }
    return "";
  }

  /// 是否需要展示连接的good图标
  bool get showGoodNumImageStrByUrl {
    return showGoodNumImageStr.isNotEmpty &&
        showGoodNumImageStr.startsWith('http');
  }

  /// 是否需要展示连接的本地图标
  bool get showGoodNumImageStrByAssets {
    return showGoodNumImageStr.isNotEmpty &&
        !showGoodNumImageStr.startsWith('http');
  }

  // 已经过期
  bool get isExpireDate => (extInfo.expireDate != null &&
      extInfo.expireDate!.isNotEmpty &&
      (DateTime.now().millisecondsSinceEpoch -
              TbrTimeUtils.formatTimeStr(extInfo.expireDate!)
                  .millisecondsSinceEpoch <
          0));

  // 已经过期超过七天
  bool get isExpireDateAfterSeven => (extInfo.expireDate != null &&
      extInfo.expireDate!.isNotEmpty &&
      (DateTime.now().millisecondsSinceEpoch -
              TbrTimeUtils.formatTimeStr(extInfo.expireDate!)
                  .add(const Duration(days: 7))
                  .millisecondsSinceEpoch <
          0));
}
