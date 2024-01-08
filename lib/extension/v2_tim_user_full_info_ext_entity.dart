import '../generated/json/base/json_field.dart';
import '../generated/json/v2_tim_user_full_info_ext_entity.g.dart';
import 'dart:convert';

import '../tencent_cloud_chat_uikit.dart';

@JsonSerializable()
class V2TimUserFullInfoExtEntity {
  @JSONField(name: "Tag_Profile_Custom_lock")
  int? tagProfileCustomLock;
  @JSONField(name: "Tag_Profile_Custom_sappid")
  int? tagProfileCustomSappid;
  @JSONField(name: "Tag_Profile_Custom_sphone")
  int? tagProfileCustomSphone;
  @JSONField(name: "Tag_Profile_Custom_userid")
  String? tagProfileCustomUserid;
  @JSONField(name: "Tag_Profile_Custom_num")
  int? tagProfileCustomNum;

  @JSONField(name: "Tag_Profile_Custom_color")
  String? tagProfileCustomColor;
  @JSONField(name: "Tag_Profile_Custom_icon")
  String? tagProfileCustomIcon;

  int? lock;
  int? sappid;
  int? sphone;
  int? num;
  String? userid;
  String? uniqueId;
  String? key;

  V2TimUserFullInfoExtEntity();

  factory V2TimUserFullInfoExtEntity.fromJson(Map<String, dynamic> json) =>
      $V2TimUserFullInfoExtEntityFromJson(json);

  Map<String, dynamic> toJson() => $V2TimUserFullInfoExtEntityToJson(this);

  V2TimUserFullInfoExtEntity copyWith(
      {int? tagProfileCustomLock,
      int? tagProfileCustomSappid,
      int? tagProfileCustomSphone,
      String? tagProfileCustomUserid,
      int? tagProfileCustomNum,
      String? tagProfileCustomColor,
      String? tagProfileCustomIcon,
      int? lock,
      int? sappid,
      int? sphone,
      String? userid,
      int? num,
      String? uniqueId,
      String? key}) {
    return V2TimUserFullInfoExtEntity()
      ..tagProfileCustomLock = tagProfileCustomLock ?? this.tagProfileCustomLock
      ..tagProfileCustomSappid =
          tagProfileCustomSappid ?? this.tagProfileCustomSappid
      ..tagProfileCustomSphone =
          tagProfileCustomSphone ?? this.tagProfileCustomSphone
      ..tagProfileCustomUserid =
          tagProfileCustomUserid ?? this.tagProfileCustomUserid
      ..tagProfileCustomNum = tagProfileCustomNum ?? this.tagProfileCustomNum
      ..tagProfileCustomColor =
          tagProfileCustomColor ?? this.tagProfileCustomColor
      ..tagProfileCustomIcon = tagProfileCustomIcon ?? this.tagProfileCustomIcon
      ..lock = lock ?? this.lock
      ..sappid = sappid ?? this.sappid
      ..sphone = sphone ?? this.sphone
      ..userid = userid ?? this.userid
      ..num = num ?? this.num
      ..key = key ?? this.key
      ..uniqueId = uniqueId ?? this.uniqueId;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}

// {"Tag_Profile_Custom_lock": 0,"Tag_Profile_Custom_sappid": 1,"Tag_Profile_Custom_sphone": 0,"Tag_Profile_Custom_userid":"a6666678", "lock": 0,"sappid": 1,"sphone": 0,"userid":"a6666678"}
extension V2TimUserFullInfoExt on V2TimUserFullInfo {
  V2TimUserFullInfoExtEntity get extInfo {
    return V2TimUserFullInfoExtEntity.fromJson(customInfo ?? {});
  }

  bool get isEnabledPhoneSearch =>
      (extInfo.sphone == 1 || extInfo.tagProfileCustomSphone == 1);

  bool get isEnabledAppIdSearch =>
      (extInfo.sappid == 1 || extInfo.tagProfileCustomSappid == 1);

  String get accid {
    if (extInfo.userid != null && extInfo.userid!.isNotEmpty) {
      return extInfo.userid!;
    }
    if (extInfo.tagProfileCustomUserid != null &&
        extInfo.tagProfileCustomUserid!.isNotEmpty) {
      return extInfo.tagProfileCustomUserid!;
    }
    return "";
  }

  int get isGoodNum =>
      (extInfo.num == 1 || extInfo.tagProfileCustomNum == 1) ? 1 : 0;

  bool get isEnabledDeviceLock =>
      (extInfo.lock == 1 || extInfo.tagProfileCustomLock == 1);

  String get nameColorHex {
    if (isGoodNum == 1) {
      String tagProfileCustomColor = extInfo.tagProfileCustomColor ?? "";
      if (tagProfileCustomColor.isNotEmpty) {
        return tagProfileCustomColor;
      }
      return "ff0000";
    }
    return "";
  }

  String get showGoodNumImageStr {
    if (isGoodNum == 1) {
      String tagProfileCustomIcon = extInfo.tagProfileCustomIcon ?? "";
      if (tagProfileCustomIcon.isNotEmpty) {
        return tagProfileCustomIcon;
      }
      return "assets/liang_fang.png";
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

}
