
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

  V2TimGroupInfoExtEntity();

  factory V2TimGroupInfoExtEntity.fromJson(Map<String, dynamic> json) =>
      $V2TimGroupInfoExtEntityFromJson(json);

  Map<String, dynamic> toJson() => $V2TimGroupInfoExtEntityToJson(this);

  V2TimGroupInfoExtEntity copyWith(
      {String? expireDate,
      int? forbidBack,
      int? higherStatus,
      int? noticeMode,
      int? privateMode}) {
    return V2TimGroupInfoExtEntity()
      ..expireDate = expireDate ?? this.expireDate
      ..forbidBack = forbidBack ?? this.forbidBack
      ..higherStatus = higherStatus ?? this.higherStatus
      ..noticeMode = noticeMode ?? this.noticeMode
      ..privateMode = privateMode ?? this.privateMode;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}

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

  V2TimGroupInfoExtEntity get extInfo =>
      V2TimGroupInfoExtEntity.fromJson(customInfo ?? {});

	// 是否开启通知
  bool get isEnabledNoticeMode => extInfo.noticeMode == 1;

	// 是否禁止撤回
  bool get isEnabledForbidBack => extInfo.forbidBack == 1;

	// 是否 vip
  bool get isNormalVip =>
      extInfo.higherStatus == 1 || extInfo.higherStatus == 2;

	// 是否 svip
  bool get isSuperVip => extInfo.higherStatus == 3;

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
